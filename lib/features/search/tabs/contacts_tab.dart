import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_contacts.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/contact_entry.dart';

class ContactsTab extends StatefulWidget {
  final List<ContactEntry>? contacts;

  const ContactsTab({super.key, this.contacts});

  @override
  State<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends State<ContactsTab> {
  bool _allowed = false;
  final Set<String> _invited = {};

  @override
  Widget build(BuildContext context) {
    if (!_allowed) {
      return _PermissionPrompt(
        onAllow: () => setState(() => _allowed = true),
      );
    }

    final list = widget.contacts ?? buildDummyContacts();
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final contact = list[i];
        final invited = _invited.contains(contact.id);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.white12,
            child: Text(
              contact.name[0],
              style: const TextStyle(
                color: Styles.tabActive,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Text(
            contact.name,
            style: const TextStyle(color: Styles.tabActive, fontSize: 17),
          ),
          subtitle: Text(
            contact.phone,
            style: const TextStyle(color: Colors.white70),
          ),
          trailing: OutlinedButton(
            onPressed:
                invited ? null : () => setState(() => _invited.add(contact.id)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Styles.accent,
              disabledForegroundColor: Colors.white38,
              shape: const StadiumBorder(),
              side: BorderSide(
                color: invited ? Colors.white24 : Styles.accent,
              ),
            ),
            child: Text(invited ? 'Invited' : 'Invite'),
          ),
        );
      },
    );
  }
}

class _PermissionPrompt extends StatelessWidget {
  final VoidCallback onAllow;

  const _PermissionPrompt({required this.onAllow});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.contacts_outlined, size: 56, color: Styles.accent),
            const SizedBox(height: 16),
            const Text(
              'Find friends in your contacts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Styles.tabActive,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'See which of your contacts are on Strava and invite the rest.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 15),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onAllow,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.accent,
                foregroundColor: Styles.tabActive,
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(horizontal: 32),
              ),
              child: const Text('Allow access'),
            ),
          ],
        ),
      ),
    );
  }
}