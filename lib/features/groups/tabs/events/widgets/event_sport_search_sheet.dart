import 'package:flutter/material.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_creation_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/sheet_handle.dart';

Future<ClubSport?> showEventSportSearchSheet(
  BuildContext context, {
  required ClubSport? selected,
}) {
  return showModalBottomSheet<ClubSport>(
    context: context,
    backgroundColor: Styles.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => _EventSportSearchSheetBody(selected: selected),
  );
}

class _EventSportSearchSheetBody extends StatefulWidget {
  final ClubSport? selected;

  const _EventSportSearchSheetBody({required this.selected});

  @override
  State<_EventSportSearchSheetBody> createState() =>
      _EventSportSearchSheetBodyState();
}

class _EventSportSearchSheetBodyState
    extends State<_EventSportSearchSheetBody> {
  final _controller = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final needle = _query.trim().toLowerCase();
    final filtered = needle.isEmpty
        ? ClubSport.option
        : ClubSport.option.where((sport) {
            final inName = sport.name.toLowerCase().contains(needle);
            final inSub =
                sport.subsports?.toLowerCase().contains(needle) ?? false;
            return inName || inSub;
          }).toList();

    final currentId = widget.selected?.id ?? ClubSport.allSports.id;
    final height = MediaQuery.of(context).size.height * 0.82;

    return SizedBox(
      height: height,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SheetHandle(),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 14, 20, 10),
              child: Text(
                'Sport',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                controller: _controller,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                cursorColor: Styles.accent,
                style: const TextStyle(fontSize: 15, color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Search sport (e.g. Running, Cycling, Yoga)',
                  hintStyle: const TextStyle(color: Styles.tabInactive),
                  prefixIcon: const Icon(
                    Icons.search,
                    color: Styles.tabInactive,
                    size: 20,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () {
                            _controller.clear();
                            setState(() => _query = '');
                          },
                          icon: const Icon(
                            Icons.close,
                            color: Styles.tabInactive,
                            size: 18,
                          ),
                        ),
                  filled: true,
                  fillColor: Palette.fieldFill,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: Palette.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: Styles.accent,
                      width: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            const Divider(height: 1, color: Palette.cardBorder),
            Expanded(
              child: filtered.isEmpty
                  ? Center(
                      child: Text(
                        'No sports found for "$_query"',
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    )
                  : ListView.separated(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) => const Divider(
                        height: 1,
                        indent: 64,
                        color: Palette.cardBorder,
                      ),
                      itemBuilder: (_, index) {
                        final sport = filtered[index];
                        final isSelected = sport.id == currentId;

                        return InkWell(
                          onTap: () => Navigator.of(context).pop(sport),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  sport.icon,
                                  size: 24,
                                  color: isSelected
                                      ? Styles.accent
                                      : Colors.white,
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        sport.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: isSelected
                                              ? FontWeight.w700
                                              : FontWeight.w500,
                                          color: isSelected
                                              ? Styles.accent
                                              : Colors.white,
                                        ),
                                      ),
                                      if (sport.subsports != null) ...[
                                        const SizedBox(height: 3),
                                        Text(
                                          sport.subsports!,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 12.5,
                                            height: 1.35,
                                            color: Styles.tabInactive,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Icon(
                                  isSelected
                                      ? Icons.radio_button_checked
                                      : Icons.radio_button_off,
                                  size: 22,
                                  color: isSelected
                                      ? Styles.accent
                                      : Styles.tabInactive,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}