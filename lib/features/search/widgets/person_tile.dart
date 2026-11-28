import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';

class PersonTile extends StatelessWidget {
  final Person person;
  final Widget trailing;

  const PersonTile({super.key, required this.person, required this.trailing});

  Widget _initialsAvatar() {
    return CircleAvatar(
      radius: 28,
      backgroundColor: Styles.surfaceHighlight,
      child: Text(
        person.initials,
        style: const TextStyle(
          color: Styles.primaryLight,
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    final photo = person.photoUrl?.trim();
    if (photo == null || photo.isEmpty) return _initialsAvatar();
    final isNetwork =
        photo.startsWith('http://') || photo.startsWith('https://');
    return ClipOval(
      child: isNetwork
          ? Image.network(
              photo,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _initialsAvatar(),
            )
          : Image.file(
              File(photo),
              width: 56,
              height: 56,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _initialsAvatar(),
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          _buildAvatar(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  person.name,
                  style: const TextStyle(
                    color: Styles.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  person.location,
                  style: const TextStyle(
                    color: Styles.textSecondary,
                    fontSize: 15,
                  ),
                ),
                Text(
                  person.tag,
                  style: const TextStyle(
                    color: Styles.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          trailing,
        ],
      ),
    );
  }
}