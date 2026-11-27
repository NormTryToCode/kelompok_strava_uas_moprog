import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/app_brand.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/contact_entry.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_people_provider.dart';

class ContactsTab extends ConsumerStatefulWidget {
  final List<ContactEntry>? contacts;

  const ContactsTab({super.key, this.contacts});

  @override
  ConsumerState<ContactsTab> createState() => _ContactsTabState();
}

class _ContactsTabState extends ConsumerState<ContactsTab> {
  bool _allowed = false;
  final Set<String> _invited = {};

  @override
  Widget build(BuildContext context) {
    if (!_allowed) {
      return _PermissionPrompt(
        onAllow: () => setState(() => _allowed = true),
      );
    }

    final list = widget.contacts ??
        ref
            .watch(searchPeopleProvider)
            .map(
              (person) => ContactEntry(
                id: person.id,
                name: person.name,
                phone: person.location,
              ),
            )
            .toList(growable: false);

    if (list.isEmpty) {
      return const Center(
        child: Text(
          'No contacts found yet',
          style: TextStyle(color: Styles.textSecondary, fontSize: 15),
        ),
      );
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final contact = list[i];
        final invited = _invited.contains(contact.id);
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Styles.surfaceElevated,
            child: Text(
              contact.name.isEmpty ? '?' : contact.name[0].toUpperCase(),
              style: const TextStyle(
                color: Styles.primaryLight,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          title: Text(
            contact.name,
            style: const TextStyle(color: Styles.textPrimary, fontSize: 17),
          ),
          subtitle: Text(
            contact.phone,
            style: const TextStyle(color: Styles.textSecondary),
          ),
          trailing: OutlinedButton(
            onPressed:
                invited ? null : () => setState(() => _invited.add(contact.id)),
            style: OutlinedButton.styleFrom(
              foregroundColor: Styles.primaryLight,
              disabledForegroundColor: Colors.white38,
              shape: const StadiumBorder(),
              side: BorderSide(
                color: invited ? Colors.white24 : Styles.primary,
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
            const Icon(
              Icons.contacts_outlined,
              size: 56,
              color: Styles.primaryLight,
            ),
            const SizedBox(height: 16),
            const Text(
              'Find friends in your contacts',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Styles.textPrimary,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'See which of your contacts are on ${AppBrand.name} and invite the rest.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Styles.textSecondary, fontSize: 15),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: onAllow,
              style: FilledButton.styleFrom(
                backgroundColor: Styles.primary,
                foregroundColor: Styles.textPrimary,
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