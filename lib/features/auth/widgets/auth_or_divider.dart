import 'package:flutter/material.dart';

/// Horizontal divider with a centered label separating authentication methods.
class AuthOrDivider extends StatelessWidget {
  final String label;

  const AuthOrDivider({
    super.key,
    this.label = 'OR',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: Colors.white54, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(
          child: Divider(color: Colors.white54, thickness: 1),
        ),
      ],
    );
  }
}
