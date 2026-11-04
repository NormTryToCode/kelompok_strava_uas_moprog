import 'package:flutter/material.dart';

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

  static const options =[
    'Sangat Tidak Puas',
    'Agak Tidak Puas',
    'Tidak Puas maupun Tidak Kecewa',
    'Agak Puas',
    'Sangat Puas',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Seberapa Puas Anda Dengan Fitur Ini?",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 8),
            ...List.generate(options.length, (index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(options[index]),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: () {
                      setState(() {
                        selectedOption = index;
                      });
                    }, 
                    icon: Icon(
                      (selectedOption == index)
                        ? Icons.check_circle
                        : Icons.circle_outlined,
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: widget.onSubmitFeedback, 
              child: const Text("KIRIM UMPAN BALIK"),
            ),
          ],
        ),
      )
    );
  }
}