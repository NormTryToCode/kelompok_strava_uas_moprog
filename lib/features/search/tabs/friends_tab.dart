import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/search/club_detail_page.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_clubs.dart';
import 'package:kelompok_strava_uas_moprog/features/search/data/dummy_people.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/club.dart';
import 'package:kelompok_strava_uas_moprog/features/search/models/person.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_all.dart';
import 'package:kelompok_strava_uas_moprog/features/search/search_history_controller.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/contacts_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/qr_code_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/tabs/suggested_tab.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/invite_button.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/recent_searches_list.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_field.dart';
import 'package:kelompok_strava_uas_moprog/features/search/widgets/search_results_view.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

class FriendsTab extends StatefulWidget {
  final FollowController? controller;
  final SearchHistoryController? history;
  final List<Person>? people;
  final List<Club>? clubs;

  const FriendsTab({
    super.key,
    this.controller,
    this.history,
    this.people,
    this.clubs,
  });

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  final TextEditingController _text = TextEditingController();
  final FocusNode _focus = FocusNode();
  late final FollowController _follow =
      widget.controller ?? FollowController.instance;
  late final SearchHistoryController _history =
      widget.history ?? SearchHistoryController.instance;
  late final List<Person> _people = widget.people ?? buildDummyPeople();
  late final List<Club> _clubs = widget.clubs ?? buildDummyClubs();
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
    _history.add(value);
  }

  void _openClub(Club club) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => ClubDetailPage(club: club)),
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
                SuggestedTab(controller: _follow, people: _people),
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

  Widget _body() {
    if (_query.trim().isNotEmpty) {
      return SearchResultsView(
        results: searchAll(_query, people: _people, clubs: _clubs),
        follow: _follow,
        onClubTap: _openClub,
      );
    }

    if (_focus.hasFocus) {
      return ListenableBuilder(
        listenable: _history,
        builder: (context, _) {
          if (_history.isEmpty) return _suggestions();
          return RecentSearchesList(
            items: _history.items,
            onSelect: _useHistory,
            onRemove: _history.remove,
            onClear: _history.clear,
          );
        },
      );
    }

    return _suggestions();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SearchField(
          hintText: 'Search Strava',
          controller: _text,
          focusNode: _focus,
          onChanged: (value) => setState(() => _query = value),
          onSubmitted: _history.add,
        ),
        Expanded(child: _body()),
      ],
    );
  }
}