import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:path_provider/path_provider.dart';
import '../../edit_profile/providers/athlete_profile_provider.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../widgets/feedback_thank_you_dialog.dart';

class FeedbackView extends ConsumerStatefulWidget {
  final VoidCallback onSubmitFeedback;

  const FeedbackView({
    super.key,
    required this.onSubmitFeedback,
  });

  @override
  ConsumerState<FeedbackView> createState() => _FeedbackViewState();
}

class _FeedbackViewState extends ConsumerState<FeedbackView> {
  int _selectedOption = -1;
  final TextEditingController _controller = TextEditingController();

  static const List<String> _options = [
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
    _loadSavedDraft();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _loadSavedDraft() async {
    try {
      final file = await _localFile;
      if (await file.exists()) {
        final savedText = await file.readAsString();
        if (!mounted) return;
        setState(() {
          _controller.text = savedText;
        });
      }
    } catch (_) {}
  }

  Future<void> _handleSendFeedback() async {
    FocusManager.instance.primaryFocus?.unfocus();

    final String athleteName = ref.read(athleteProfileProvider).fullName;
    final String ratingLabel =
      _selectedOption >= 0 ? _options[_selectedOption] : 'Tidak memilih';
    final String comment = _controller.text.trim();

    try {
      final file = await _localFile;
      await file.writeAsString(comment);
    } catch (_) {}

    try {
      final String docId = 'fb_${DateTime.now().millisecondsSinceEpoch}';
      await DatabaseService.instance.save('athlete_feedbacks', docId, {
        'athleteName': athleteName,
        'rating': ratingLabel,
        'comment': comment,
        'submittedAt': DateTime.now().toIso8601String(),
      });
    } catch (_) {
      if (mounted) {
        ProfileSnackbarHelper.showInfo(
          context,
          'Umpan balik disimpan lokal (sedang offline).',
        );
      }
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return FeedbackThankYouDialog(
          onConfirmOk: widget.onSubmitFeedback,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 14.0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: widget.onSubmitFeedback,
                      child: const Icon(
                        Icons.arrow_back,
                        color: Styles.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "Bagikan Umpan Balik",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Styles.textPrimary,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: _handleSendFeedback,
                  child: Text(
                    "KIRIM",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: (_selectedOption != -1 ||
                        _controller.text.trim().isNotEmpty)
                          ? Styles.accent
                          : Styles.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 28),
            const Text(
              "Seberapa tidak puas atau puas Anda dengan fitur ini?",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            ...List.generate(_options.length, (index) {
              final bool isSelected = (_selectedOption == index);
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedOption = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _options[index],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Styles.textPrimary,
                        ),
                      ),
                      Icon(
                        isSelected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                        color: isSelected ? Styles.accent : Styles.textPrimary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 28),
            const Text(
              "Komentar Tambahan",
              style: TextStyle(
                fontSize: 16,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 120,
              child: CupertinoTextField(
                maxLines: null,
                expands: true,
                autocorrect: false,
                textAlignVertical: TextAlignVertical.top,
                controller: _controller,
                onChanged: (_) {
                  setState(() {});
                },
                placeholder: 'Apa yang membantu? Tidak membantu?',
                placeholderStyle: const TextStyle(
                  fontSize: 15,
                  color: Styles.textMuted,
                ),
                padding: EdgeInsets.zero,
                style: const TextStyle(
                  fontSize: 15,
                  color: Styles.textPrimary,
                ),
                decoration: const BoxDecoration(
                  color: Styles.canvas,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}