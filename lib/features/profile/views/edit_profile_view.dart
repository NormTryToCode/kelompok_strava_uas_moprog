import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/athlete_profile_data.dart';
import '../widgets/athlete_avatar_widget.dart';
import '../widgets/profile_labeled_field.dart';
import '../widgets/profile_option_dialog.dart';
import '../widgets/profile_photo_dialog.dart';
import '../widgets/unsaved_changes_dialog.dart';

class EditProfileView extends StatefulWidget {
  final AthleteProfileData initialData;
  final ValueChanged<AthleteProfileData> onSaveProfile;
  final VoidCallback onCancel;

  const EditProfileView({
    super.key,
    required this.initialData,
    required this.onSaveProfile,
    required this.onCancel,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  late String _selectedSport;
  late String _selectedGender;
  late DateTime _selectedBirthDate;
  late String _avatarPath;

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();
  final ImagePicker _imagePicker = ImagePicker();

  static const List<String> _sportOptions = [
    'Berlari',
    'Bersepeda',
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
    _applyDataToFields(widget.initialData);
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
    final initial = widget.initialData;
    return _firstNameController.text != initial.firstName ||
        _lastNameController.text != initial.lastName ||
        _cityController.text != initial.city ||
        _countryController.text != initial.country ||
        _bioController.text != initial.bio ||
        _weightController.text != initial.weightKg ||
        _selectedSport != initial.primarySport ||
        _selectedGender != initial.gender ||
        _formatDate(_selectedBirthDate) != initial.birthDate ||
        _avatarPath != initial.avatarPath;
  }

  Future<AthleteProfileData> _saveToPreferences() async {
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

    await _asyncPrefs.setString('first_name', updatedData.firstName);
    await _asyncPrefs.setString('last_name', updatedData.lastName);
    await _asyncPrefs.setString('city', updatedData.city);
    await _asyncPrefs.setString('country', updatedData.country);
    await _asyncPrefs.setString('sport', updatedData.primarySport);
    await _asyncPrefs.setString('text', updatedData.bio);
    await _asyncPrefs.setString('birth_date', updatedData.birthDate);
    await _asyncPrefs.setString('gender', updatedData.gender);
    await _asyncPrefs.setString('weight_kg', updatedData.weightKg);
    await _asyncPrefs.setString('avatar_path', updatedData.avatarPath);

    return updatedData;
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

    final updatedData = await _saveToPreferences();
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;
    Navigator.of(context).pop();
    widget.onSaveProfile(updatedData);
  }

  void _handleBackNavigation() {
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_hasUnsavedChanges) {
      widget.onCancel();
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return UnsavedChangesDialog(
          onSave: _handleSaveWithLoading,
          onDiscard: widget.onCancel,
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
      );
      if (pickedFile != null && mounted) {
        setState(() {
          _avatarPath = pickedFile.path;
        });
      }
    } catch (_) {}
  }

  void _showPhotoPickerDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ProfilePhotoDialog(
          onTakePhoto: () => _pickImage(ImageSource.camera),
          onPickFromGallery: () => _pickImage(ImageSource.gallery),
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
                      color: Styles.tabActive,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Center(
              child: GestureDetector(
                onTap: _showPhotoPickerDialog,
                child: AthleteAvatarWidget(
                  avatarPath: _avatarPath,
                  size: 76,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 165,
                  child: ProfileLabeledField(
                    label: 'Nama depan',
                    controller: _firstNameController,
                    placeholder: 'Nama depan',
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(
                  width: 165,
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 165,
                  child: ProfileLabeledField(
                    label: 'Kota',
                    controller: _cityController,
                    placeholder: 'Kota',
                    textCapitalization: TextCapitalization.sentences,
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: ProfileLabeledField(
                    label: 'Negara',
                    controller: _countryController,
                    placeholder: 'INDONESIA',
                    textCapitalization: TextCapitalization.characters,
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