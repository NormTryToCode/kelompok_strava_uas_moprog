import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/athlete_profile_data.dart';
import '../widgets/custom_image_network.dart';
import '../widgets/profile_labeled_field.dart';
import '../widgets/profile_option_dialog.dart';
import '../widgets/top_buttons.dart';

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
  bool _googleFitSwitch = false;
  String _statusMessage = '';

  final SharedPreferencesAsync _asyncPrefs = SharedPreferencesAsync();

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
    _googleFitSwitch = data.googleFitConnected;
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

  void load() async {
    final String firstName =
        await _asyncPrefs.getString('first_name') ?? widget.initialData.firstName;
    final String lastName =
        await _asyncPrefs.getString('last_name') ?? widget.initialData.lastName;
    final String city =
        await _asyncPrefs.getString('city') ?? widget.initialData.city;
    final String country =
        await _asyncPrefs.getString('country') ?? widget.initialData.country;
    final String sport =
        await _asyncPrefs.getString('sport') ?? widget.initialData.primarySport;
    final String savedBio =
        await _asyncPrefs.getString('text') ?? widget.initialData.bio;
    final String birthDate =
        await _asyncPrefs.getString('birth_date') ?? widget.initialData.birthDate;
    final String gender =
        await _asyncPrefs.getString('gender') ?? widget.initialData.gender;
    final String weight =
        await _asyncPrefs.getString('weight_kg') ?? widget.initialData.weightKg;
    final bool savedSwitch = await _asyncPrefs.getBool('switch') ?? false;

    if (!mounted) return;
    setState(() {
      _firstNameController.text = firstName;
      _lastNameController.text = lastName;
      _cityController.text = city;
      _countryController.text = country;
      _selectedSport = sport;
      _bioController.text = savedBio;
      _selectedBirthDate = _parseDateString(birthDate);
      _selectedGender = gender;
      _weightController.text = weight;
      _googleFitSwitch = savedSwitch;
      _statusMessage = 'Data profil berhasil dimuat dari Shared Preferences.';
    });
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
      googleFitConnected: _googleFitSwitch,
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
    await _asyncPrefs.setBool('switch', updatedData.googleFitConnected);

    return updatedData;
  }

  void save() async {
    await _saveToPreferences();
    if (!mounted) return;
    setState(() {
      _statusMessage = 'Seluruh perubahan profil berhasil disimpan!';
    });
  }

  void reset() {
    setState(() {
      _bioController.text = '';
      _googleFitSwitch = false;
      _statusMessage = 'Kolom Bio & status Google Fit telah di-reset.';
    });
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
      firstDate: DateTime(1950),
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
                      onTap: widget.onCancel,
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
                  onTap: () async {
                    final updatedData = await _saveToPreferences();
                    if (!mounted) return;
                    widget.onSaveProfile(updatedData);
                  },
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
            const SizedBox(height: 16),
            const Center(
              child: SizedBox(
                width: 72,
                height: 72,
                child: CustomImageNetwork(
                  imageUrl:
                      'https://cdn-icons-png.flaticon.com/512/4140/4140048.png',
                  height: 72,
                ),
              ),
            ),
            TopButtons(
              onLoadPressed: load,
              onSavePressed: save,
              onResetPressed: reset,
            ),
            if (_statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  _statusMessage,
                  style: const TextStyle(fontSize: 12, color: Styles.active),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 165,
                  child: ProfileLabeledField(
                    label: 'Nama depan',
                    controller: _firstNameController,
                    placeholder: 'Nama depan',
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: ProfileLabeledField(
                    label: 'Nama belakang',
                    controller: _lastNameController,
                    placeholder: 'Nama belakang',
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
                  ),
                ),
                SizedBox(
                  width: 165,
                  child: ProfileLabeledField(
                    label: 'Negara',
                    controller: _countryController,
                    placeholder: 'Negara',
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
            Container(
              decoration: BoxDecoration(
                color: Styles.background,
                border: Border.all(color: Styles.inactive, width: 1.2),
                borderRadius: BorderRadius.circular(8.0),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.favorite_border, color: Styles.accent),
                      SizedBox(width: 10),
                      Text(
                        'Hubungkan ke Google Fit',
                        style: TextStyle(fontSize: 13, color: Styles.accent),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: _googleFitSwitch,
                    onChanged: (bool value) {
                      setState(() {
                        _googleFitSwitch = value;
                      });
                    },
                  ),
                ],
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
            ),
          ],
        ),
      ),
    );
  }
}