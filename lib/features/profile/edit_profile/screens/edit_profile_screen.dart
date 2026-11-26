import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/athlete_profile_data.dart';
import '../providers/athlete_profile_provider.dart';
import '../../shared/services/profile_image_service.dart';
import '../../shared/services/profile_location_service.dart';
import '../../shared/utils/profile_page_route.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../../shared/widgets/athlete_avatar_widget.dart';
import '../../shared/widgets/profile_labeled_field.dart';
import '../widgets/profile_option_dialog.dart';
import '../widgets/profile_photo_dialog.dart';
import '../widgets/unsaved_changes_dialog.dart';
import 'profile_photo_crop_screen.dart';

class EditProfileView extends ConsumerStatefulWidget {
  final VoidCallback onDone;

  const EditProfileView({
    super.key,
    required this.onDone,
  });

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late AthleteProfileData _initialData;
  late String _selectedSport;
  late String _selectedGender;
  late DateTime _selectedBirthDate;
  late String _avatarPath;

  String _gpsStatusText = '';
  bool _gpsHasError = false;
  bool _isScanningGps = false;

  final ProfileImageService _imageService = ProfileImageService();
  final ProfileLocationService _locationService = ProfileLocationService();

  static const List<String> _sportOptions = [
    'Running',
    'Cycling',
    'Swimming',
  ];

  static const List<String> _genderOptions = [
    'Male',
    'Female',
    'Non-binary',
    'Prefer not to say',
  ];

  @override
  void initState() {
    super.initState();
    final rawInitial = ref.read(athleteProfileProvider);
    _initialData = rawInitial.copyWith(
      primarySport: normalizeAthleteSport(rawInitial.primarySport),
      gender: normalizeAthleteGender(rawInitial.gender),
    );
    _applyDataToFields(_initialData);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _cityController.dispose();
    _countryController.dispose();
    _bioController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _applyDataToFields(AthleteProfileData data) {
    _firstNameController.text = data.firstName;
    _lastNameController.text = data.lastName;
    _cityController.text = data.city;
    _countryController.text = data.country;
    _bioController.text = data.bio;
    _weightController.text = data.weightKg;
    _selectedSport = normalizeAthleteSport(data.primarySport);
    _selectedGender = normalizeAthleteGender(data.gender);
    _avatarPath = data.avatarPath;
    _selectedBirthDate = _parseDateString(data.birthDate);
  }

  DateTime _parseDateString(String rawDate) {
    final parts = rawDate.split('/');
    if (parts.length == 3) {
      final int day = int.tryParse(parts[0]) ?? 30;
      final int month = int.tryParse(parts[1]) ?? 8;
      final int year = int.tryParse(parts[2]) ?? 2007;
      return DateTime(year, month, day);
    }
    return DateTime(2007, 8, 30);
  }

  String _formatDate(DateTime date) {
    final String day = date.day.toString().padLeft(2, '0');
    final String month = date.month.toString().padLeft(2, '0');
    final String year = date.year.toString();
    return '$day/$month/$year';
  }

  bool get _hasUnsavedChanges {
    return _firstNameController.text != _initialData.firstName ||
      _lastNameController.text != _initialData.lastName ||
      _cityController.text != _initialData.city ||
      _countryController.text != _initialData.country ||
      _bioController.text != _initialData.bio ||
      _weightController.text != _initialData.weightKg ||
      _selectedSport != _initialData.primarySport ||
      _selectedGender != _initialData.gender ||
      _formatDate(_selectedBirthDate) != _initialData.birthDate ||
      _avatarPath != _initialData.avatarPath;
  }

  Future<void> _handleSaveWithLoading() async {
    FocusManager.instance.primaryFocus?.unfocus();

    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return const SavingProfileDialog();
      },
    );

    final updatedData = AthleteProfileData(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      city: _cityController.text.trim(),
      country: _countryController.text.trim(),
      primarySport: _selectedSport,
      bio: _bioController.text.trim(),
      birthDate: _formatDate(_selectedBirthDate),
      gender: _selectedGender,
      weightKg: _weightController.text.trim(),
      avatarPath: _avatarPath,
    );

    final bool syncedToCloud = await ref
      .read(athleteProfileProvider.notifier)
      .saveProfile(updatedData);
    await Future.delayed(const Duration(milliseconds: 450));

    if (!mounted) return;
    Navigator.of(context).pop();

    if (syncedToCloud) {
      ProfileSnackbarHelper.showSuccess(
        context,
        'Athlete Passport saved & synced to cloud!',
      );
    } else {
      ProfileSnackbarHelper.showInfo(
        context,
        'Passport saved locally (offline mode).',
      );
    }
    widget.onDone();
  }

  void _handleBackNavigation() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_hasUnsavedChanges) {
      widget.onDone();
      return;
    }

    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return UnsavedChangesDialog(
          onSave: _handleSaveWithLoading,
          onDiscard: widget.onDone,
        );
      },
    );
  }

  Future<void> _detectCurrentGpsLocation() async {
    if (_isScanningGps) return;
    setState(() {
      _isScanningGps = true;
    });

    try {
      await _locationService.getCurrentLocation();
      if (!mounted) return;
      final String latShort = _locationService.lat.toStringAsFixed(4);
      final String lngShort = _locationService.lng.toStringAsFixed(4);
      setState(() {
        _isScanningGps = false;
        _gpsHasError = false;
        _gpsStatusText = 'GPS Locked  •  Lat $latShort, Lng $lngShort';
      });
      ProfileSnackbarHelper.showSuccess(
        context,
        'Live GPS coordinates detected!',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isScanningGps = false;
        _gpsHasError = true;
        _gpsStatusText = e.toString();
      });
      ProfileSnackbarHelper.showError(context, 'Unable to read GPS: $e');
    }
  }

  Future<void> _pickImage({required bool fromCamera}) async {
    try {
      final File? file = fromCamera
        ? await _imageService.pickFromCamera()
        : await _imageService.pickFromGallery();

      if (!mounted) return;
      if (file == null) {
        ProfileSnackbarHelper.showInfo(context, 'Photo selection cancelled.');
        return;
      }

      final String? croppedPath = await Navigator.push<String>(
        context,
        buildProfileRoute<String>(ProfilePhotoCropScreen(imageFile: file)),
      );

      if (croppedPath != null && mounted) {
        setState(() {
          _avatarPath = croppedPath;
        });
        ProfileSnackbarHelper.showSuccess(
          context,
          fromCamera
            ? 'Passport photo captured from Camera!'
            : 'Passport photo updated from Gallery!',
        );
      }
    } catch (e) {
      if (!mounted) return;
      ProfileSnackbarHelper.showError(context, 'Photo error: $e');
    }
  }

  void _showPhotoPickerDialog() {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return ProfilePhotoDialog(
          onTakePhoto: () => _pickImage(fromCamera: true),
          onPickFromGallery: () => _pickImage(fromCamera: false),
        );
      },
    );
  }

  void _showSportDialog() {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return ProfileOptionDialog(
          title: 'Primary Discipline',
          options: _sportOptions,
          selectedValue: _selectedSport,
          onSelected: (String value) {
            setState(() {
              _selectedSport = value;
            });
          },
        );
      },
    );
  }

  void _showGenderDialog() {
    showDialog(
      context: context,
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return ProfileOptionDialog(
          title: 'Gender Identity',
          options: _genderOptions,
          selectedValue: _selectedGender,
          onSelected: (String value) {
            setState(() {
              _selectedGender = value;
            });
          },
        );
      },
    );
  }

  void _pickBirthDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedBirthDate,
      firstDate: DateTime(1930),
      lastDate: DateTime(2026, 12, 31),
      helpText: 'SELECT BIRTH DATE',
      cancelText: 'Cancel',
      confirmText: 'Confirm',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: buildProfileDarkTheme(),
          child: child!,
        );
      },
    );

    if (picked != null && mounted) {
      setState(() {
        _selectedBirthDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: _handleBackNavigation,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Styles.surfaceElevated,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Styles.borderStrong),
                        ),
                        child: const Icon(
                          Icons.arrow_back_rounded,
                          color: Styles.textPrimary,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Athlete Passport',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          Text(
                            'Identity, Location & Biometrics',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Styles.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Styles.surfaceHighlight,
                  foregroundColor: Styles.primaryLight,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Styles.primary),
                  ),
                ),
                onPressed: _handleSaveWithLoading,
                child: const Text(
                  'SAVE',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.6,
                  ),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1, color: Styles.border),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 20,
                  ),
                  decoration: Styles.cardDecoration(
                    radius: Radii.card,
                    highlighted: true,
                    withGlow: true,
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: _showPhotoPickerDialog,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: Styles.primaryGradient,
                                boxShadow: Styles.glow(
                                  intensity: 0.35,
                                  blur: 18,
                                ),
                              ),
                              child: AthleteAvatarWidget(
                                avatarPath: _avatarPath,
                                size: 86,
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: -2,
                              child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  gradient: Styles.primaryGradient,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Styles.canvas,
                                    width: 2.2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 16,
                                  color: Styles.canvas,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: _showPhotoPickerDialog,
                        child: const Text(
                          'Update Passport Portrait',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            color: Styles.primaryLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 3),
                      const Text(
                        'Tap to capture or crop a square athlete avatar',
                        style: TextStyle(
                          fontSize: 11.5,
                          color: Styles.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                const _PassportSectionTitle(
                  title: '01  •  ATHLETE IDENTITY',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ProfileLabeledField(
                        label: 'First Name',
                        controller: _firstNameController,
                        placeholder: 'First name',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ProfileLabeledField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        placeholder: 'Last name',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Primary Discipline',
                  valueText: _selectedSport,
                  onTap: _showSportDialog,
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Athlete Bio',
                  controller: _bioController,
                  placeholder: 'Write a short training motto or goal...',
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: 22),
                const _PassportSectionTitle(
                  title: '02  •  LOCATION & GPS',
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: ProfileLabeledField(
                        label: 'Home City',
                        controller: _cityController,
                        placeholder: 'City',
                        textCapitalization: TextCapitalization.words,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ProfileLabeledField(
                        label: 'Country',
                        controller: _countryController,
                        placeholder: 'INDONESIA',
                        textCapitalization: TextCapitalization.characters,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Material(
                  color: Styles.surface,
                  borderRadius: BorderRadius.circular(Radii.field),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.field),
                    onTap: _detectCurrentGpsLocation,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Radii.field),
                        border: Border.all(
                          color: _gpsStatusText.isNotEmpty
                            ? (_gpsHasError ? Styles.danger : Styles.success)
                                .withValues(alpha: 0.6)
                            : Styles.borderStrong,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              color: Styles.surfaceHighlight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _isScanningGps
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Styles.primaryLight,
                                  ),
                                )
                              : Icon(
                                  _gpsStatusText.isNotEmpty && !_gpsHasError
                                    ? Icons.my_location_rounded
                                    : Icons.radar_rounded,
                                  size: 16,
                                  color: _gpsHasError
                                    ? Styles.danger
                                    : _gpsStatusText.isNotEmpty
                                      ? Styles.success
                                      : Styles.primaryLight,
                                ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Verify Live GPS Coordinates',
                                  style: TextStyle(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: Styles.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  _gpsStatusText.isNotEmpty
                                    ? _gpsStatusText
                                    : 'Tap to ping device satellite fix',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _gpsHasError
                                      ? Styles.danger
                                      : _gpsStatusText.isNotEmpty
                                        ? Styles.success
                                        : Styles.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(
                            Icons.chevron_right_rounded,
                            color: Styles.primaryLight,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 22),
                const _PassportSectionTitle(
                  title: '03  •  BIOMETRICS & TELEMETRY',
                ),
                const SizedBox(height: 4),
                const Text(
                  'Used to calibrate calorie expenditure, effort index, and power zones.',
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Styles.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Date of Birth',
                  valueText: _formatDate(_selectedBirthDate),
                  onTap: _pickBirthDate,
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Gender Identity',
                  valueText: _selectedGender,
                  onTap: _showGenderDialog,
                ),
                const SizedBox(height: 12),
                ProfileLabeledField(
                  label: 'Body Weight (kg)',
                  controller: _weightController,
                  placeholder: '74.0',
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
                  ],
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: Styles.buttonDecoration(
                      radius: Radii.button,
                      withGlow: true,
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Styles.canvas,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Radii.button),
                        ),
                      ),
                      onPressed: _handleSaveWithLoading,
                      icon: const Icon(Icons.verified_outlined, size: 19),
                      label: const Text(
                        'Save Athlete Passport',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ], 
            ),   
          ),     
        ),      
      ],         
    );         
  }
}

class _PassportSectionTitle extends StatelessWidget {
  final String title;

  const _PassportSectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 13,
          decoration: BoxDecoration(
            gradient: Styles.primaryGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: Styles.primaryLight,
          ),
        ),
      ],
    );
  }
}