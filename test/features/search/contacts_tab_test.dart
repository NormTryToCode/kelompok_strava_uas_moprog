import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/contact_entry.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/contacts_tab.dart';

void main() {
  const contacts = [
    ContactEntry(id: 'c1', name: 'Aulia Rahma', phone: '0812 0000 0001'),
  ];

  testWidgets('menampilkan ajakan izin sebelum daftar kontak', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ContactsTab(contacts: contacts))),
    );

    expect(find.text('Find friends in your contacts'), findsOneWidget);
    expect(find.text('Aulia Rahma'), findsNothing);
  });

  testWidgets('setelah diizinkan, kontak tampil dan Invite menjadi Invited',
      (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ContactsTab(contacts: contacts))),
    );

    await tester.tap(find.text('Allow access'));
    await tester.pump();

    expect(find.text('Aulia Rahma'), findsOneWidget);

    await tester.tap(find.text('Invite'));
    await tester.pump();

    expect(find.text('Invited'), findsOneWidget);
  });
}