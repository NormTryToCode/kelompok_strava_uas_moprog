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
      barrierColor: const Color.fromARGB(210, 7, 6, 12),
      builder: (BuildContext context) {
        return FeedbackThankYouDialog(
          onConfirmOk: widget.onSubmitFeedback,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool canSend =
      _selectedOption != -1 || _controller.text.trim().isNotEmpty;

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
                Expanded(
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: widget.onSubmitFeedback,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Styles.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Flexible(
                        child: Text(
                          'Bagikan Umpan Balik',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Styles.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _handleSendFeedback,
                  child: Text(
                    'KIRIM',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color:
                        canSend ? Styles.primaryLight : Styles.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text(
              'Seberapa tidak puas atau puas Anda dengan fitur ini?',
              style: TextStyle(
                fontSize: 18,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 18),
            ...List.generate(_options.length, (index) {
              final bool isSelected = (_selectedOption == index);
              return Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Material(
                  color: isSelected
                    ? Styles.surfaceHighlight.withValues(alpha: 0.75)
                    : Styles.surface,
                  borderRadius: BorderRadius.circular(Radii.chip),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(Radii.chip),
                    onTap: () {
                      setState(() {
                        _selectedOption = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14.0,
                        vertical: 14.0,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Radii.chip),
                        border: Border.all(
                          color: isSelected
                            ? Styles.primaryLight
                            : Styles.borderStrong,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _options[index],
                              style: TextStyle(
                                fontSize: 15.5,
                                fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                                color: isSelected
                                  ? Styles.primaryLight
                                  : Styles.textPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(
                            isSelected
                              ? Icons.radio_button_checked
                              : Icons.radio_button_off,
                            color: isSelected
                              ? Styles.primaryLight
                              : Styles.textSecondary,
                            size: 23,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 20),
            const Text(
              'Komentar Tambahan',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Styles.textPrimary,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              height: 130,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Styles.fieldFill,
                borderRadius: BorderRadius.circular(Radii.field),
                border: Border.all(color: Styles.borderStrong, width: 1.2),
              ),
              child: CupertinoTextField(
                maxLines: null,
                expands: true,
                autocorrect: false,
                textAlignVertical: TextAlignVertical.top,
                controller: _controller,
                cursorColor: Styles.primaryLight,
                onChanged: (_) {
                  setState(() {});
                },
                placeholder: 'Apa yang membantu? Apa yang perlu ditingkatkan?',
                placeholderStyle: TextStyle(
                  fontSize: 14.5,
                  color: Styles.textSecondary.withValues(alpha: 0.72),
                ),
                padding: EdgeInsets.zero,
                style: const TextStyle(
                  fontSize: 15,
                  color: Styles.textPrimary,
                ),
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}