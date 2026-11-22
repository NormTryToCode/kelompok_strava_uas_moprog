import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_invite_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/club_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/invite_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/services/club_share_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_invite/club_qr_code_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_share/share_club_page.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/models/friend.dart';

class InviteClubPage extends ConsumerStatefulWidget {
  final Club club;

  const InviteClubPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => InviteClubPage(club: club)),
    );
  }

  @override
  ConsumerState<InviteClubPage> createState() => _InviteClubPageState();
}

class _InviteClubPageState extends ConsumerState<InviteClubPage> {
  final _searchController = TextEditingController();
  final _selectedIds = <String>{};
  String _query = '';
  bool _sending = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _copyLink(Club club) async {
    await Clipboard.setData(
      ClipboardData(text: ClubShareService.clubUrl(club)),
    );
    _showSnack('Club link copied');
  }

  void _toggleSelection(String friendId) {
    setState(() {
      if (!_selectedIds.remove(friendId)) {
        _selectedIds.add(friendId);
      }
    });
  }

  Future<void> _sendInvites(Club club, List<Friend> allFriends) async {
    if (_selectedIds.isEmpty || _sending) return;

    final chosen = allFriends
        .where((f) => _selectedIds.contains(f.id))
        .toList();
    if (chosen.isEmpty) return;

    setState(() => _sending = true);
    try {
      final count = await ref
          .read(clubInvitesProvider(club.id).notifier)
          .inviteFriends(chosen);
      if (!mounted) return;

      setState(() {
        _selectedIds.clear();
        _sending = false;
      });

      if (count > 0) {
        final label = count == 1 ? '1 person' : '$count people';
        _showSnack('Invited $label to ${club.name}');
      }
    } catch (_) {
      if (!mounted) return;
      setState(() => _sending = false);
      _showSnack('Could not send invites. Please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final clubs = ref.watch(clubsProvider).valueOrNull ?? const <Club>[];
    final club = clubs.firstWhere(
      (c) => c.id == widget.club.id,
      orElse: () => widget.club,
    );

    final friendsAsync = ref.watch(invitableFriendsProvider);
    final invitesAsync = ref.watch(clubInvitesProvider(club.id));
    final invitedIds = {
      for (final invite in invitesAsync.valueOrNull ?? const <ClubInvite>[])
        invite.friendId,
    };

    final allFriends = friendsAsync.valueOrNull ?? const <Friend>[];
    final canInvite = _selectedIds.isNotEmpty && !_sending;

    return Scaffold(
      backgroundColor: Styles.background,
      appBar: AppBar(
        backgroundColor: Styles.background,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Invite to Club',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        actions: [
          TextButton(
            onPressed: canInvite ? () => _sendInvites(club, allFriends) : null,
            style: TextButton.styleFrom(
              foregroundColor: Styles.accent,
              disabledForegroundColor: Styles.tabInactive.withAlpha(90),
            ),
            child: Text(
              _sending
                  ? 'SENDING'
                  : _selectedIds.isEmpty
                      ? 'INVITE'
                      : 'INVITE (${_selectedIds.length})',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 14, 24, 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _QuickInviteAction(
                  icon: Icons.link,
                  label: 'Copy link',
                  onTap: () => _copyLink(club),
                ),
                _QuickInviteAction(
                  icon: Icons.qr_code_2,
                  label: 'QR Code',
                  onTap: () => ClubQrCodePage.open(context, club),
                ),
                _QuickInviteAction(
                  icon: Icons.share_outlined,
                  label: 'Share',
                  onTap: () => ShareClubPage.open(context, club),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _query = value),
              textInputAction: TextInputAction.search,
              cursorColor: Styles.accent,
              style: const TextStyle(fontSize: 15.5, color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search people who follow you',
                hintStyle: const TextStyle(color: Styles.tabInactive),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Styles.tabInactive,
                  size: 21,
                ),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(
                          Icons.close,
                          color: Styles.tabInactive,
                          size: 19,
                        ),
                      ),
                filled: true,
                fillColor: Styles.surface,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: const BorderSide(color: Palette.cardBorder),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
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
            child: friendsAsync.when(
              loading: () => const Center(
                child: CircularProgressIndicator(color: Styles.accent),
              ),
              error: (_, _) => Center(
                child: TextButton(
                  onPressed: () => ref.invalidate(invitableFriendsProvider),
                  style: TextButton.styleFrom(foregroundColor: Styles.accent),
                  child: const Text('Could not load friends. Try again'),
                ),
              ),
              data: (friends) {
                final needle = _query.trim().toLowerCase();
                final filtered = needle.isEmpty
                    ? friends
                    : friends
                        .where(
                          (f) =>
                              f.name.toLowerCase().contains(needle) ||
                              f.username.toLowerCase().contains(needle),
                        )
                        .toList();

                if (filtered.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        friends.isEmpty
                            ? 'No followers available to invite yet.'
                            : 'No people found for "$_query".',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 14.5,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  itemCount: filtered.length,
                  separatorBuilder: (_, _) => const Divider(
                    height: 1,
                    indent: 72,
                    color: Palette.cardBorder,
                  ),
                  itemBuilder: (_, index) {
                    final friend = filtered[index];
                    final isInvited = invitedIds.contains(friend.id);
                    final isSelected = _selectedIds.contains(friend.id);

                    return _InvitableFriendTile(
                      friend: friend,
                      invited: isInvited,
                      selected: isSelected,
                      onTap: isInvited
                          ? null
                          : () => _toggleSelection(friend.id),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickInviteAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _QuickInviteAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Material(
            color: Styles.surface,
            shape: const CircleBorder(
              side: BorderSide(color: Palette.cardBorder),
            ),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onTap,
              child: SizedBox(
                width: 58,
                height: 58,
                child: Icon(icon, color: Colors.white, size: 24),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _InvitableFriendTile extends StatelessWidget {
  final Friend friend;
  final bool invited;
  final bool selected;
  final VoidCallback? onTap;

  const _InvitableFriendTile({
    required this.friend,
    required this.invited,
    required this.selected,
    required this.onTap,
  });

  String get _initial {
    final trimmed = friend.name.trim();
    return trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected
                    ? Styles.accent.withAlpha(32)
                    : Styles.surface,
                border: Border.all(
                  color: selected ? Styles.accent : Palette.cardBorder,
                ),
              ),
              child: Text(
                _initial,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: selected ? Styles.accent : Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friend.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '@${friend.username}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Styles.tabInactive,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            if (invited)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Styles.surface,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Palette.cardBorder),
                ),
                child: const Text(
                  'Invited',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Styles.tabInactive,
                  ),
                ),
              )
            else
              Icon(
                selected
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                size: 22,
                color: selected ? Styles.accent : Styles.tabInactive,
              ),
          ],
        ),
      ),
    );
  }
}