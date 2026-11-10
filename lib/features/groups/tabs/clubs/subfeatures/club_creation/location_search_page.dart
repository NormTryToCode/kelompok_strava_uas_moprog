import 'dart:async';

import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/utils/location_search.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_creation/widgets/location_result_tile.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';

enum _Status { idle, loading, success, error }

class LocationSearchPage extends StatefulWidget {
  const LocationSearchPage({super.key});

  static Future<ClubLocation?> open(BuildContext context) {
    return Navigator.of(context).push<ClubLocation>(
      MaterialPageRoute(builder: (_) => const LocationSearchPage()),
    );
  }

  @override
  State<LocationSearchPage> createState() => _LocationSearchPageState();
}

class _LocationSearchPageState extends State<LocationSearchPage> {
  static const _minChars = 2;
  static const _debounceDuration = Duration(milliseconds: 400);

  final _service = LocationSearch();
  final _controller = TextEditingController();

  Timer? _debounce;
  int _requestId = 0;
  _Status _status = _Status.idle;
  List<ClubLocation> _results = const [];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _service.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    final query = value.trim();

    if (query.length < _minChars) {
      _requestId++;
      setState(() {
        _status = _Status.idle;
        _results = const [];
      });
      return;
    }

    setState(() => _status = _Status.loading);
    _debounce = Timer(_debounceDuration, () => _search(query));
  }

  Future<void> _search(String query) async {
    final id = ++_requestId;
    try {
      final results = await _service.search(query);
      if (!mounted || id != _requestId) return;
      setState(() {
        _results = results;
        _status = _Status.success;
      });
    } catch (_) {
      if (!mounted || id != _requestId) return;
      setState(() => _status = _Status.error);
    }
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Styles.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  Expanded(
                    child: _SearchField(
                      controller: _controller,
                      onChanged: _onChanged,
                      onClear: _clear,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: _buildBody()),
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Place data \u00a9 OpenStreetMap contributors',
                style: TextStyle(fontSize: 11, color: Styles.tabInactive),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    switch (_status) {
      case _Status.idle:
        return const _Message(
          icon: Icons.travel_explore,
          text: 'Search for a city, region, or country',
        );
      case _Status.loading:
        return const Center(
          child: CircularProgressIndicator(color: Palette.teal),
        );
      case _Status.error:
        return _Message(
          icon: Icons.wifi_off_rounded,
          text: 'Search isn\u2019t available right now.',
          actionLabel: 'Try again',
          onAction: () => _search(_controller.text.trim()),
        );
      case _Status.success:
        if (_results.isEmpty) {
          return const _Message(
            icon: Icons.search_off,
            text: 'No places found',
          );
        }
        return ListView.separated(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          itemCount: _results.length,
          separatorBuilder: (_, __) => const Divider(
            height: 1,
            indent: 74,
            color: Palette.cardBorder,
          ),
          itemBuilder: (_, i) => LocationResultTile(
            location: _results[i],
            onTap: () => Navigator.of(context).pop(_results[i]),
          ),
        );
    }
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onClear;

  const _SearchField({
    required this.controller,
    required this.onChanged,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    OutlineInputBorder border(Color color, double width) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(Radii.field),
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: controller,
      onChanged: onChanged,
      autofocus: true,
      textInputAction: TextInputAction.search,
      cursorColor: Palette.teal,
      style: const TextStyle(fontSize: 16, color: Colors.white),
      decoration: InputDecoration(
        hintText: 'Search places',
        hintStyle: const TextStyle(color: Styles.tabInactive),
        prefixIcon: const Icon(Icons.search, color: Styles.tabInactive),
        suffixIcon: ValueListenableBuilder<TextEditingValue>(
          valueListenable: controller,
          builder: (_, value, __) => value.text.isEmpty
              ? const SizedBox.shrink()
              : IconButton(
                  onPressed: onClear,
                  icon: const Icon(Icons.close, color: Colors.white),
                ),
        ),
        filled: true,
        fillColor: Styles.surface,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        enabledBorder: border(Palette.cardBorder, 1.2),
        focusedBorder: border(Palette.teal, 1.8),
      ),
    );
  }
}

class _Message extends StatelessWidget {
  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _Message({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBubble(icon, size: 56),
            const SizedBox(height: 14),
            Text(
              text,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 15, color: Styles.tabInactive),
            ),
            if (actionLabel != null)
              TextButton(
                onPressed: onAction,
                style: TextButton.styleFrom(foregroundColor: Styles.accent),
                child: Text(actionLabel!),
              ),
          ],
        ),
      ),
    );
  }
}
