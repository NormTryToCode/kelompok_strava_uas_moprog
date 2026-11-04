import 'package:flutter/material.dart';

class TrophyCard extends StatelessWidget {
  final String imageURL;
  final String milestoneTitle;

  const TrophyCard({
    super.key,
    required this.imageURL,
    required this.milestoneTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 75,
            child: Image(
              image: NetworkImage(imageURL),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            milestoneTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }
}