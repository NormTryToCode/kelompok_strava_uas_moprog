import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../widgets/top_buttons.dart';

class EditProfileView extends StatefulWidget {
  final String sportCategory;
  final int weightKg;
  final String initialBio;
  final VoidCallback onToggleSport;
  final VoidCallback onDecreaseWeight;
  final VoidCallback onIncreaseWeight;
  final ValueChanged<String> onBioSaved;
  final VoidCallback onSaveProfile;

  const EditProfileView({
    super.key,
    required this.sportCategory,
    required this.weightKg,
    required this.initialBio,
    required this.onToggleSport,
    required this.onDecreaseWeight,
    required this.onIncreaseWeight,
    required this.onBioSaved,
    required this.onSaveProfile,
  });

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  TextEditingController controller = TextEditingController();
  bool switchValue = false;
  String statusMessage = '';

  final SharedPreferencesAsync asyncPrefs = SharedPreferencesAsync();

  @override
  void initState() {
    super.initState();
    controller.text = widget.initialBio;
    load();
  }

  void load() async {
    String savedText = await asyncPrefs.getString('text') ?? '';
    bool savedSwitch = await asyncPrefs.getBool('switch') ?? false;
    if (!mounted) return;
    setState(() {
      if (savedText.isNotEmpty) {
        controller.text = savedText;
      }
      switchValue = savedSwitch;
      statusMessage = 'Data profil berhasil di-load dari Shared Preferences.';
    });
    widget.onBioSaved(controller.text);
  }

  void save() async {
    await asyncPrefs.setString('text', controller.text);
    await asyncPrefs.setBool('switch', switchValue);
    widget.onBioSaved(controller.text);
    if (!mounted) return;
    setState(() {
      statusMessage = 'Bio & pengaturan Google Fit tersimpan!';
    });
  }

  void reset() {
    setState(() {
      controller.text = '';
      switchValue = false;
      statusMessage = 'Input Bio & Google Fit di-reset.';
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: widget.onSaveProfile,
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Styles.tabActive,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      "Edit Profil",
                      style: TextStyle(fontSize: 20, color: Styles.tabActive),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    save();
                    widget.onSaveProfile();
                  },
                  child: const Text(
                    "SELESAI",
                    style: TextStyle(color: Styles.accent),
                  ),
                ),
              ],
            ),
            TopButtons(
              onLoadPressed: load,
              onSavePressed: save,
              onResetPressed: reset,
            ),
            if (statusMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Text(
                  statusMessage,
                  style: const TextStyle(fontSize: 12, color: Styles.active),
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 165,
                  color: Styles.surface,
                  padding: const EdgeInsets.all(10.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama depan",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.tabInactive,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Michael",
                        style: TextStyle(fontSize: 15, color: Styles.tabActive),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 165,
                  color: Styles.surface,
                  padding: const EdgeInsets.all(10.0),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nama belakang",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.tabInactive,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Respati Sanjaya Ho",
                        style: TextStyle(fontSize: 15, color: Styles.tabActive),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              color: Styles.surface,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Olahraga Utama",
                        style: TextStyle(
                          fontSize: 11,
                          color: Styles.tabInactive,
                        ),
                      ),
                      Text(
                        widget.sportCategory,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Styles.tabActive,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: widget.onToggleSport,
                    child: const Text("Ubah"),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Bio Atlet (Shared Preferences)',
              style: TextStyle(fontSize: 13, color: Styles.tabActive),
            ),
            const SizedBox(height: 6),
            SizedBox(
              height: 80,
              child: CupertinoTextField(
                maxLines: null,
                expands: true,
                autocorrect: false,
                controller: controller,
                placeholder: 'Tulis bio lari / bersepeda Anda di sini...',
                placeholderStyle: const TextStyle(color: Styles.tabInactive),
                style: const TextStyle(color: Styles.tabActive),
                decoration: const BoxDecoration(color: Styles.surface),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "INFORMASI ATLET",
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Styles.tabActive,
              ),
            ),
            const Text(
              "Digunakan untuk menghitung kalori, kekuatan, dan lainnya",
              style: TextStyle(fontSize: 12, color: Styles.tabInactive),
            ),
            const SizedBox(height: 8),
            Container(
              color: Styles.surface,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.favorite_border, color: Styles.accent),
                      SizedBox(width: 8),
                      Text(
                        'Hubungkan ke Google Fit',
                        style: TextStyle(fontSize: 13, color: Styles.accent),
                      ),
                    ],
                  ),
                  CupertinoSwitch(
                    value: switchValue,
                    onChanged: (bool value) {
                      setState(() {
                        switchValue = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Styles.surface,
              padding: const EdgeInsets.all(10.0),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Tanggal Lahir: 30/08/2007",
                    style: TextStyle(fontSize: 13, color: Styles.tabActive),
                  ),
                  Text(
                    "Jenis Kelamin: Pria",
                    style: TextStyle(fontSize: 13, color: Styles.tabActive),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Styles.surface,
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Berat (kg): ${widget.weightKg} kg",
                    style: const TextStyle(
                      fontSize: 15,
                      color: Styles.tabActive,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton.filled(
                        onPressed: widget.onDecreaseWeight,
                        icon: const Icon(Icons.remove),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: widget.onIncreaseWeight,
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}