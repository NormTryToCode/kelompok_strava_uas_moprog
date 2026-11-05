import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:lorem_ipsum/lorem_ipsum.dart';
import 'package:path_provider/path_provider.dart';
import '../widgets/top_buttons.dart';

class FeedbackView extends StatefulWidget {
  final VoidCallback onSubmitFeedback;

  const FeedbackView({
    super.key,
    required this.onSubmitFeedback,
  });

  @override
  State<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends State<FeedbackView> {
  int selectedOption = 4;
  TextEditingController controller = TextEditingController();

  static const options = [
    'Sangat tidak puas',
    'Agak tidak puas',
    'Tidak puas maupun tidak kecewa',
    'Agak puas',
    'Sangat puas',
  ];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/text_storage.txt');
  }

  @override
  void initState() {
    super.initState();
    load();
  }

  void load() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final savedText = await file.readAsString();
        setState(() {
          controller.text = savedText;
        });
      }
    } catch (e) {
      setState(() {
        controller.text = '';
      });
    }
  }

  void save() async {
    final file = await _localFile;
    await file.writeAsString(controller.text);
  }

  void generate() {
    setState(() {
      controller.text = loremIpsum(words: 60, paragraphs: 2);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                    onPressed: widget.onSubmitFeedback,
                    icon: const Icon(Icons.arrow_back, color: Styles.tabActive),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Bagikan Umpan Balik",
                    style: TextStyle(fontSize: 19, color: Styles.tabActive),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  save();
                  widget.onSubmitFeedback();
                },
                child: const Text(
                  "KIRIM",
                  style: TextStyle(color: Styles.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Seberapa tidak puas atau puas Anda dengan fitur ini?",
            style: TextStyle(fontSize: 16, color: Styles.tabActive),
          ),
          const SizedBox(height: 6),
          ...List.generate(options.length, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedOption = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      options[index],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Styles.tabActive,
                      ),
                    ),
                    Icon(
                      (selectedOption == index)
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: (selectedOption == index)
                          ? Styles.accent
                          : Styles.tabInactive,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          const Text(
            "Komentar Tambahan (File Storage: text_storage.txt)",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Styles.tabActive,
            ),
          ),
          TopButtons(
            onLoadPressed: load,
            onSavePressed: save,
            onResetPressed: generate,
            thirdButtonText: 'Generate',
          ),
          Expanded(
            child: CupertinoTextField(
              maxLines: null,
              expands: true,
              autocorrect: false,
              textAlignVertical: TextAlignVertical.top,
              controller: controller,
              placeholder: 'Apa yang membantu? Tidak membantu?',
              placeholderStyle: const TextStyle(color: Styles.tabInactive),
              style: const TextStyle(color: Styles.tabActive),
              decoration: const BoxDecoration(color: Styles.surface),
            ),
          ),
        ],
      ),
    );
  }
}