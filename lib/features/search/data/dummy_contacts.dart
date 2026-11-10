import 'package:kelompok_strava_uas_moprog/features/search/models/contact_entry.dart';

List<ContactEntry> buildDummyContacts() {
  return const [
    ContactEntry(id: 'c1', name: 'Aulia Rahma', phone: '0812 0000 0001'),
    ContactEntry(id: 'c2', name: 'Fajar Nugroho', phone: '0812 0000 0002'),
    ContactEntry(id: 'c3', name: 'Intan Permata', phone: '0812 0000 0003'),
    ContactEntry(id: 'c4', name: 'Yoga Saputra', phone: '0812 0000 0004'),
  ];
}