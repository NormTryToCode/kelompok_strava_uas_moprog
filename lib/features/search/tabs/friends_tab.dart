import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_people.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_all.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/contacts_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/qr_code_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/suggested_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/invite_button.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/recent_searches_list.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_results_view.dart';

class FriendsTab extends ConsumerStatefulWidget {
  final List<Person>? people;
  final List<SearchClub>? clubs;

  const FriendsTab({
    super.key,
    this.people,
    this.clubs,
  });

  @override
  ConsumerState<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends ConsumerState<FriendsTab> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();
  late final List<Person> _people = widget.people ?? buildDummyPeople();
  late final List<SearchClub> _clubs = widget.clubs ?? buildDummyClubs();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focus.removeListener(_onFocusChange);
    _focus.dispose();
    _text.dispose();
    super.dispose();
  }

  void _onFocusChange() => setState(() {});

  void _useHistory(String value) {
    _text.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
    setState(() => _query = value);
    ref.read(searchHistoryProvider.notifier).add(value);
  }

  void _openClub(SearchClub club) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => SearchClubDetailPage(club: club)),
    );
  }

  Widget _suggestions() {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          const TabBar(
            indicatorColor: Styles.accent,
            labelColor: Styles.tabActive,
            unselectedLabelColor: Colors.white54,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            tabs: [
              Tab(icon: Icon(Icons.people_outline), text: 'Suggested'),
              Tab(icon: Icon(Icons.contacts_outlined), text: 'Contacts'),
              Tab(icon: Icon(Icons.qr_code_scanner), text: 'QR Code'),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                SuggestedTab(people: _people),
                const ContactsTab(),
                const QrCodeTab(),
              ],
            ),
          ),
          const InviteButton(),
        ],
      ),
    );
  }

  Widget _body(List<String> history) {
    if (_query.trim().isNotEmpty) {
      return SearchResultsView(
        results: searchAll(_query, people: _people, clubs: _clubs),
        onClubTap: _openClub,
      );
    }

    if (_focus.hasFocus && history.isNotEmpty) {
      final notifier = ref.read(searchHistoryProvider.notifier);
      return RecentSearchesList(
        items: history,
        onSelect: _useHistory,
        onRemove: notifier.remove,
        onClear: notifier.clear,
      );
    }

    return _suggestions();
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(searchHistoryProvider);
    return Column(
      children: [
        SearchField(
          hintText: 'Search Strava',
          controller: _text,
          focusNode: _focus,
          onChanged: (value) => setState(() => _query = value),
          onSubmitted: (value) =>
              ref.read(searchHistoryProvider.notifier).add(value),
        ),
        Expanded(child: _body(history)),
      ],
    );
  }
}