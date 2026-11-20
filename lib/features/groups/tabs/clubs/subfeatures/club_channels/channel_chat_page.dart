import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/core/theme/styles.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/club_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/providers/channel_provider.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/icon_bubble.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/widgets/info_chip.dart';

class ChannelChatPage extends ConsumerStatefulWidget {
  final Club club;
  final String channelId;

  const ChannelChatPage({
    super.key,
    required this.club,
    required this.channelId,
  });

  static Future<void> open(
    BuildContext context, {
    required Club club,
    required String channelId,
  }) {
    return Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute<void>(
        builder: (_) => ChannelChatPage(club: club, channelId: channelId),
      ),
    );
  }

  @override
  ConsumerState<ChannelChatPage> createState() => _ChannelChatPageState();
}

class _ChannelChatPageState extends ConsumerState<ChannelChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    await ref
        .read(clubChannelsProvider(widget.club.id).notifier)
        .sendMessage(channelId: widget.channelId, content: text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _confirmDelete(ClubChannel channel) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Styles.surface,
        title: const Text(
          'Delete channel?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'All messages in "${channel.name}" will be removed.',
          style: const TextStyle(color: Styles.tabInactive),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Styles.tabInactive),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: const Text(
              'Delete',
              style: TextStyle(
                color: Styles.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;
    await ref
        .read(clubChannelsProvider(widget.club.id).notifier)
        .deleteChannel(channel.id);
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  @override
  Widget build(BuildContext context) {
    final channelsAsync = ref.watch(clubChannelsProvider(widget.club.id));

    return channelsAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Styles.background,
        body: Center(child: CircularProgressIndicator(color: Palette.teal)),
      ),
      error: (_, _) => const Scaffold(
        backgroundColor: Styles.background,
        body: Center(
          child: Text(
            'Unable to open channel.',
            style: TextStyle(color: Styles.tabInactive),
          ),
        ),
      ),
      data: (channels) {
        final match = channels.where((c) => c.id == widget.channelId);
        if (match.isEmpty) {
          return Scaffold(
            backgroundColor: Styles.background,
            appBar: AppBar(
              backgroundColor: Styles.background,
              foregroundColor: Colors.white,
            ),
            body: const Center(
              child: Text(
                'Channel no longer exists.',
                style: TextStyle(color: Styles.tabInactive),
              ),
            ),
          );
        }

        final channel = match.first;
        final iconColor = channel.category == ChannelCategory.announcement
            ? Styles.accent
            : Palette.teal;

        return Scaffold(
          backgroundColor: Styles.background,
          appBar: AppBar(
            backgroundColor: Styles.surface,
            surfaceTintColor: Colors.transparent,
            foregroundColor: Colors.white,
            titleSpacing: 0,
            title: Row(
              children: [
                IconBubble(channel.category.icon, size: 36, color: iconColor),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        channel.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${channel.category.label} \u00b7 ${channel.postPermission.title}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Styles.tabInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              if (!channel.isDefault)
                IconButton(
                  onPressed: () => _confirmDelete(channel),
                  icon: const Icon(Icons.delete_outline, color: Styles.accent),
                  tooltip: 'Delete channel',
                ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: channel.messages.isEmpty
                    ? _EmptyChatState(channel: channel)
                    : ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                        itemCount: channel.messages.length,
                        itemBuilder: (_, index) {
                          final msg = channel.messages[index];
                          return _MessageBubble(
                            message: msg,
                            timeLabel: _formatTime(msg.sentAt),
                          );
                        },
                      ),
              ),
              Container(
                decoration: const BoxDecoration(
                  color: Styles.surface,
                  border: Border(top: BorderSide(color: Palette.cardBorder)),
                ),
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.send,
                            onSubmitted: (_) => _sendMessage(),
                            cursorColor: Palette.teal,
                            style: const TextStyle(
                              fontSize: 15,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Message #${channel.name}',
                              hintStyle:
                                  const TextStyle(color: Styles.tabInactive),
                              filled: true,
                              fillColor: Palette.fieldFill,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide:
                                    const BorderSide(color: Palette.cardBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: const BorderSide(
                                  color: Palette.teal,
                                  width: 1.5,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Material(
                          color: Styles.accent,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _sendMessage,
                            child: const SizedBox(
                              width: 44,
                              height: 44,
                              child: Icon(
                                Icons.send_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EmptyChatState extends StatelessWidget {
  final ClubChannel channel;

  const _EmptyChatState({required this.channel});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconBubble(channel.category.icon, size: 60),
            const SizedBox(height: 14),
            Text(
              'Welcome to ${channel.name}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            if (channel.description.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                channel.description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  height: 1.4,
                  color: Styles.tabInactive,
                ),
              ),
            ],
            const SizedBox(height: 14),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 8,
              runSpacing: 6,
              children: [
                InfoChip(
                  icon: channel.membership.icon,
                  label: channel.membership.title,
                ),
                InfoChip(
                  icon: channel.postPermission.icon,
                  label: channel.postPermission.title,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChannelMessage message;
  final String timeLabel;

  const _MessageBubble({
    required this.message,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isCurrentUser;

    return Align(
      alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.76,
        ),
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
        decoration: BoxDecoration(
          color: isMine ? Palette.selectedFill : Styles.surface,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMine ? 18 : 4),
            bottomRight: Radius.circular(isMine ? 4 : 18),
          ),
          border: Border.all(
            color: isMine ? Palette.teal.withAlpha(120) : Palette.cardBorder,
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (!isMine) ...[
              Text(
                message.senderName,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Palette.teal,
                ),
              ),
              const SizedBox(height: 3),
            ],
            Text(
              message.content,
              style: const TextStyle(
                fontSize: 15,
                height: 1.35,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  timeLabel,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Styles.tabInactive,
                  ),
                ),
                if (isMine) ...[
                  const SizedBox(width: 4),
                  const Icon(Icons.done_all, size: 14, color: Palette.teal),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}