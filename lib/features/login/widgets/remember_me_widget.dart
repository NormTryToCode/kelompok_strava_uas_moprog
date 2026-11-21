import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';

class RememberMeWidget extends StatefulWidget {
  final String checkBoxDescription;

  const RememberMeWidget({super.key, required this.checkBoxDescription});

  @override
  State<RememberMeWidget> createState() => _RememberMeWidgetState();
}

class _RememberMeWidgetState extends State<RememberMeWidget> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Checkbox(

      value: isChecked, 
      onChanged: (value) {
        setState(() {
            isChecked = value ?? false;
          });
        },
        activeColor: Styles.badge,
        side : const BorderSide(color: Colors.white)
      ),
      Text(widget.checkBoxDescription, style: TextStyle(color: Colors.white),),
    ],
    );
  }
}
