import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/channel_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/channel_chat_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/create_channel_page.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/widgets/channel_category_filter.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/widgets/channel_list_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/subfeatures/club_channels/widgets/club_channels_header_card.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/section_title.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/soft_card.dart';

class ClubChannelsPage extends ConsumerStatefulWidget {
  final Club club;

  const ClubChannelsPage({super.key, required this.club});

  static Future<void> open(BuildContext context, Club club) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(builder: (_) => ClubChannelsPage(club: club)),
    );
  }

  @override
  ConsumerState<ClubChannelsPage> createState() => _ClubChannelsPageState();
}

class _ClubChannelsPageState extends ConsumerState<ClubChannelsPage> {
  ChannelCategory? _selectedCategory;

  Future<void> _onCreateChannel() async {
    final created = await CreateChannelPage.open(context, widget.club);
    if (created == null || !mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('${created.name} channel created')));
  }

  Future<void> _onOpenChannel(ClubChannel channel) async {
    if (channel.unreadCount > 0) {
      await ref
          .read(clubChannelsProvider(widget.club.id).notifier)
          .markAsRead(channel.id);
    }
    if (!mounted) return;
    await ChannelChatPage.open(
      context,
      club: widget.club,
      channelId: channel.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(clubChannelsProvider(widget.club.id));

    return Scaffold(
      backgroundColor: Styles.canvas,
      appBar: AppBar(
        backgroundColor: Styles.canvas,
        surfaceTintColor: Colors.transparent,
        foregroundColor: Colors.white,
        title: const Text(
          'Club Channels',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onCreateChannel,
        backgroundColor: Styles.accent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Radii.button),
        ),
        icon: const Icon(Icons.add_comment_outlined),
        label: const Text(
          'New channel',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: channelsAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: Styles.teal)),
        error: (_, _) => Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const IconBubble(Icons.error_outline, size: 54),
                const SizedBox(height: 12),
                const Text(
                  'Could not load channels.',
                  style: TextStyle(
                    fontSize: 15,
                    color: Styles.surfaceHighlight,
                  ),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () =>
                      ref.invalidate(clubChannelsProvider(widget.club.id)),
                  style: TextButton.styleFrom(foregroundColor: Styles.teal),
                  child: const Text('Try again'),
                ),
              ],
            ),
          ),
        ),
        data: (channels) {
          final filtered = _selectedCategory == null
              ? channels
              : channels.where((c) => c.category == _selectedCategory).toList();

          return ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: ClubChannelsHeaderCard(
                  club: widget.club,
                  channelCount: channels.length,
                ),
              ),
              ChannelCategoryFilter(
                selected: _selectedCategory,
                onChanged: (category) =>
                    setState(() => _selectedCategory = category),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle(
                  _selectedCategory == null
                      ? 'All channels'
                      : _selectedCategory!.label,
                ),
              ),
              const SizedBox(height: 12),
              if (filtered.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: _EmptyFilterState(),
                )
              else
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      for (var i = 0; i < filtered.length; i++) ...[
                        if (i > 0) const SizedBox(height: 10),
                        ChannelListCard(
                          channel: filtered[i],
                          onTap: () => _onOpenChannel(filtered[i]),
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState();

  @override
  Widget build(BuildContext context) {
    return const SoftCard(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Column(
        children: [
          IconBubble(Icons.forum_outlined, size: 52),
          SizedBox(height: 12),
          Text(
            'No channels in this category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tap "New channel" to start a conversation here.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13.5, color: Styles.surfaceHighlight),
          ),
        ],
      ),
    );
  }
}

