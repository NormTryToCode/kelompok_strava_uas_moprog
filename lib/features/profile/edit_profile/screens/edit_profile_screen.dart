import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import '../models/athlete_profile_data.dart';
import '../providers/athlete_profile_provider.dart';
import '../../shared/services/profile_image_service.dart';
import '../../shared/services/profile_location_service.dart';
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

  double _gpsLat = 0.0;
  double _gpsLng = 0.0;
  String _gpsStatusText = '';

  final ProfileImageService _imageService = ProfileImageService();
  final ProfileLocationService _locationService = ProfileLocationService();

  static const List<String> _sportOptions = [
    'Berlari',
    'Bersepeda',
    'Berenang',
  ];

  static const List<String> _genderOptions = [
    'Pria',
    'Wanita',
    'Non-biner',
    'Memilih tidak mengatakan',
  ];

  @override
  void initState() {
    super.initState();
    _initialData = ref.read(athleteProfileProvider);
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
    _selectedSport = data.primarySport;
    _selectedGender = data.gender;
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
      builder: (BuildContext context) {
        return const SavingProfileDialog();
      },
    );

    final updatedData = AthleteProfileData(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      city: _cityController.text,
      country: _countryController.text,
      primarySport: _selectedSport,
      bio: _bioController.text,
      birthDate: _formatDate(_selectedBirthDate),
      gender: _selectedGender,
      weightKg: _weightController.text,
      avatarPath: _avatarPath,
    );

    final bool syncedToCloud = await ref
      .read(athleteProfileProvider.notifier)
      .saveProfile(updatedData);
    await Future.delayed(const Duration(milliseconds: 500));

    if (!mounted) return;
    Navigator.of(context).pop();

    if (syncedToCloud) {
      ProfileSnackbarHelper.showSuccess(
        context,
        'Profil berhasil disimpan & disinkronkan ke Firebase!',
      );
    } else {
      ProfileSnackbarHelper.showInfo(
        context,
        'Profil tersimpan di perangkat (mode offline).',
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
      builder: (BuildContext context) {
        return UnsavedChangesDialog(
          onSave: _handleSaveWithLoading,
          onDiscard: widget.onDone,
        );
      },
    );
  }

  Future<void> _detectCurrentGpsLocation() async {
    try {
      await _locationService.getCurrentLocation();
      if (!mounted) return;
      setState(() {
        _gpsLat = _locationService.lat;
        _gpsLng = _locationService.lng;
        _gpsStatusText = 'Lat: $_gpsLat, Lng: $_gpsLng';
      });
      ProfileSnackbarHelper.showSuccess(
        context,
        'Koordinat GPS berhasil dideteksi!',
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _gpsStatusText = e.toString();
      });
      ProfileSnackbarHelper.showError(context, 'Gagal membaca GPS: $e');
    }
  }

  Future<void> _pickImage({required bool fromCamera}) async {
    try {
      final File? file = fromCamera
        ? await _imageService.pickFromCamera()
        : await _imageService.pickFromGallery();

      if (!mounted) return;
      if (file == null) {
        ProfileSnackbarHelper.showInfo(context, 'Pemilihan gambar dibatalkan.');
        return;
      }

      final String? croppedPath = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
            ProfilePhotoCropScreen(imageFile: file),
        ),
      );

      if (croppedPath != null && mounted) {
        setState(() {
          _avatarPath = croppedPath;
        });
        ProfileSnackbarHelper.showSuccess(
          context,
          fromCamera
            ? 'Berhasil memperbarui foto dari Kamera!'
            : 'Berhasil memperbarui foto dari Galeri!',
        );
      }
    } catch (e) {
      if (!mounted) return;
      ProfileSnackbarHelper.showError(context, 'Terjadi error: $e');
    }
  }

  void _showPhotoPickerDialog() {
    showDialog(
      context: context,
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
      builder: (BuildContext context) {
        return ProfileOptionDialog(
          title: 'Olahraga Utama',
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
      builder: (BuildContext context) {
        return ProfileOptionDialog(
          title: 'Jenis Kelamin',
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
      helpText: 'Pilih tanggal',
      cancelText: 'Batalkan',
      confirmText: 'OK',
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Styles.accent,
              onPrimary: Styles.tabActive,
              surface: Styles.surface,
              onSurface: Styles.tabActive,
            ),
          ),
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: _handleBackNavigation,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      "Edit Profil",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Styles.tabActive,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _handleSaveWithLoading,
                  child: const Text(
                    "SELESAI",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Styles.accent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _showPhotoPickerDialog,
                child: Column(
                  children: [
                    AthleteAvatarWidget(
                      avatarPath: _avatarPath,
                      size: 80,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ubah Foto Profil',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Styles.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ProfileLabeledField(
                    label: 'Nama depan',
                    controller: _firstNameController,
                    placeholder: 'Nama depan',
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProfileLabeledField(
                    label: 'Nama belakang',
                    controller: _lastNameController,
                    placeholder: 'Nama belakang',
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ProfileLabeledField(
                    label: 'Kota',
                    controller: _cityController,
                    placeholder: 'Kota',
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ProfileLabeledField(
                    label: 'Negara',
                    controller: _countryController,
                    placeholder: 'INDONESIA',
                    textCapitalization: TextCapitalization.characters,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: _detectCurrentGpsLocation,
                  child: const Row(
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 16,
                        color: Styles.accent,
                      ),
                      SizedBox(width: 6),
                      Text(
                        'Cek Koordinat GPS Saat Ini',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Styles.accent,
                        ),
                      ),
                    ],
                  ),
                ),
                if (_gpsStatusText.isNotEmpty)
                  Flexible(
                    child: Text(
                      _gpsStatusText,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Styles.active,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            ProfileLabeledField(
              label: 'Olahraga Utama',
              valueText: _selectedSport,
              onTap: _showSportDialog,
            ),
            const SizedBox(height: 12),
            ProfileLabeledField(
              label: 'Bio',
              controller: _bioController,
              placeholder: 'Tulis bio singkat Anda...',
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 20),
            const Text(
              "INFORMASI ATLET",
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Styles.tabActive,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Digunakan untuk menghitung kalori, kekuatan, dan lainnya",
              style: TextStyle(
                fontSize: 12,
                color: Styles.tabInactive,
              ),
            ),
            const SizedBox(height: 12),
            ProfileLabeledField(
              label: 'Tanggal Lahir',
              valueText: _formatDate(_selectedBirthDate),
              onTap: _pickBirthDate,
            ),
            const SizedBox(height: 12),
            ProfileLabeledField(
              label: 'Jenis Kelamin',
              valueText: _selectedGender,
              onTap: _showGenderDialog,
            ),
            const SizedBox(height: 12),
            ProfileLabeledField(
              label: 'Berat (kg)',
              controller: _weightController,
              placeholder: '74,0',
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}