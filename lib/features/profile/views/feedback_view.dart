import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

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

  static const options = [
    'Sangat tidak puas',
    'Agak tidak puas',
    'Tidak puas maupun tidak kecewa',
    'Agak puas',
    'Sangat puas',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
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
                onPressed: widget.onSubmitFeedback,
                child: const Text(
                  "KIRIM",
                  style: TextStyle(color: Styles.accent),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            "Seberapa tidak puas atau puas Anda dengan fitur ini?",
            style: TextStyle(fontSize: 17, color: Styles.tabActive),
          ),
          const SizedBox(height: 16),
          ...List.generate(options.length, (index) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    options[index],
                    style: const TextStyle(
                      fontSize: 15,
                      color: Styles.tabActive,
                    ),
                  ),
                  IconButton.filled(
                    onPressed: () {
                      setState(() {
                        selectedOption = index;
                      });
                    },
                    icon: Icon(
                      (selectedOption == index)
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: (selectedOption == index)
                          ? Styles.accent
                          : Styles.tabInactive,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text(
            "Komentar Tambahan",
            style: TextStyle(fontSize: 15, color: Styles.tabActive),
          ),
          const SizedBox(height: 6),
          const Text(
            "Apa yang membantu? Tidak membantu?",
            style: TextStyle(fontSize: 14, color: Styles.tabInactive),
          ),
        ],
      ),
    );
  }
}