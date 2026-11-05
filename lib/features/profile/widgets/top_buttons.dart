import 'package:flutter/cupertino.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class TopButtons extends StatelessWidget {
  const TopButtons({
    super.key,
    required this.onLoadPressed,
    required this.onSavePressed,
    required this.onResetPressed,
    this.thirdButtonText = 'Reset',
  });
  
  final VoidCallback onLoadPressed;
  final VoidCallback onSavePressed;
  final VoidCallback onResetPressed;
  final String thirdButtonText;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CupertinoButton(
          onPressed: onLoadPressed,
          child: const Text(
            'Load',
            style: TextStyle(color: Styles.accent),
          ),
        ),
        CupertinoButton(
          onPressed: onSavePressed,
          child: const Text(
            'Save',
            style: TextStyle(color: Styles.active),
          ), 
        ),
        CupertinoButton( 
          onPressed: onResetPressed,
          child: Text(
            thirdButtonText,
            style: const TextStyle(color: Styles.tabInactive),
          ),
        )
      ],
    );
  }
}