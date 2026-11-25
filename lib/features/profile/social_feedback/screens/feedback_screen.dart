import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:path_provider/path_provider.dart';
import '../../edit_profile/providers/athlete_profile_provider.dart';
import '../../shared/utils/profile_snackbar_helper.dart';
import '../widgets/feedback_thank_you_dialog.dart';

class _PulseOption {
  final String label;
  final String hint;
  final IconData icon;

  const _PulseOption({
    required this.label,
    required this.hint,
    required this.icon,
  });
}

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

  static const List<_PulseOption> _options = [
    _PulseOption(
      label: 'Very Dissatisfied',
      hint: 'Major friction or missing essentials',
      icon: Icons.sentiment_very_dissatisfied_rounded,
    ),
    _PulseOption(
      label: 'Somewhat Dissatisfied',
      hint: 'Needs noticeable polish',
      icon: Icons.sentiment_dissatisfied_rounded,
    ),
    _PulseOption(
      label: 'Neutral',
      hint: 'Works okay, room to elevate',
      icon: Icons.sentiment_neutral_rounded,
    ),
    _PulseOption(
      label: 'Satisfied',
      hint: 'Smooth and helpful experience',
      icon: Icons.sentiment_satisfied_rounded,
    ),
    _PulseOption(
      label: 'Very Satisfied',
      hint: 'Fast, inspiring, and effortless',
      icon: Icons.sentiment_very_satisfied_rounded,
    ),
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
      _selectedOption >= 0 ? _options[_selectedOption].label : 'Unrated';
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
          'Feedback saved locally (offline mode).',
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
                      onTap: widget.onSubmitFeedback,
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
                            'Product Pulse',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: Styles.textPrimary,
                            ),
                          ),
                          Text(
                            'Help Shape ${AppBrand.name}',
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
                  backgroundColor:
                    canSend ? Styles.surfaceHighlight : Styles.surface,
                  foregroundColor:
                    canSend ? Styles.primaryLight : Styles.textSecondary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 7,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: canSend ? Styles.primary : Styles.borderStrong,
                    ),
                  ),
                ),
                onPressed: _handleSendFeedback,
                child: const Text(
                  'SEND',
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
                  padding: const EdgeInsets.all(16),
                  decoration: Styles.cardDecoration(
                    radius: Radii.card,
                    highlighted: true,
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ATHLETE EXPERIENCE CHECK-IN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.0,
                          color: Styles.primaryLight,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'How satisfied are you with your ${AppBrand.name} Profile & Telemetry?',
                        style: TextStyle(
                          fontSize: 17,
                          height: 1.35,
                          fontWeight: FontWeight.w800,
                          color: Styles.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                ...List.generate(_options.length, (index) {
                  final option = _options[index];
                  final bool isSelected = (_selectedOption == index);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: Material(
                      color: isSelected
                        ? Styles.surfaceHighlight.withValues(alpha: 0.78)
                        : Styles.surface,
                      borderRadius: BorderRadius.circular(Radii.field),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(Radii.field),
                        onTap: () {
                          setState(() {
                            _selectedOption = index;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 13.0,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Radii.field),
                            border: Border.all(
                              color: isSelected
                                ? Styles.primaryLight
                                : Styles.borderStrong,
                              width: isSelected ? 1.4 : 1.0,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: isSelected
                                    ? Styles.primary.withValues(alpha: 0.25)
                                    : Styles.surfaceElevated,
                                  borderRadius: BorderRadius.circular(11),
                                ),
                                child: Icon(
                                  option.icon,
                                  size: 22,
                                  color: isSelected
                                    ? Styles.primaryLight
                                    : Styles.textSecondary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      option.label,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: isSelected
                                          ? FontWeight.w800
                                          : FontWeight.w600,
                                        color: isSelected
                                          ? Styles.primaryLight
                                          : Styles.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      option.hint,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Styles.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isSelected
                                  ? Icons.radio_button_checked_rounded
                                  : Icons.radio_button_off_rounded,
                                color: isSelected
                                  ? Styles.primaryLight
                                  : Styles.textSecondary,
                                size: 22,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 14),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ADDITIONAL NOTES',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.0,
                        color: Styles.primaryLight,
                      ),
                    ),
                    Text(
                      'Auto-cached locally',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Styles.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  height: 132,
                  padding: const EdgeInsets.all(14),
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
                    placeholder:
                      'What stood out? What can we make even sharper?',
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
                const SizedBox(height: 20),
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
                      onPressed: _handleSendFeedback,
                      icon: const Icon(Icons.send_rounded, size: 18),
                      label: const Text(
                        'Submit Product Pulse',
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