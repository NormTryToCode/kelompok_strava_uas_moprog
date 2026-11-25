import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/channel_repository.dart';

final channelRepositoryProvider = Provider<ChannelRepository>((ref) {
  return ChannelRepository();
});

class ClubChannelsNotifier extends FamilyAsyncNotifier<List<ClubChannel>, String> {
  ChannelRepository get _repository => ref.read(channelRepositoryProvider);

  @override
  Future<List<ClubChannel>> build(String arg) async {
    return _repository.getChannelsByClub(arg);
  }

  Future<ClubChannel> createChannel({
    required String name,
    String description = '',
    ChannelCategory category = ChannelCategory.discussion,
    ChannelMembership membership = ChannelMembership.everyone,
    ChannelPostPermission postPermission = ChannelPostPermission.everyone,
  }) async {
    final now = DateTime.now();
    final channel = ClubChannel(
      id: now.microsecondsSinceEpoch.toString(),
      clubId: arg,
      name: name.trim(),
      description: description.trim(),
      category: category,
      membership: membership,
      postPermission: postPermission,
      createdAt: now,
    );

    final created = await _repository.createChannel(channel);
    final current = state.valueOrNull ?? [];
    state = AsyncData([...current, created]);
    return created;
  }

  Future<void> sendMessage({
    required String channelId,
    required String content,
    String senderName = 'You',
    bool isCurrentUser = true,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) return;

    final now = DateTime.now();
    final message = ChannelMessage(
      id: now.microsecondsSinceEpoch.toString(),
      senderName: senderName,
      content: trimmed,
      sentAt: now,
      isCurrentUser: isCurrentUser,
    );

    final updated = await _repository.sendMessage(
      channelId: channelId,
      message: message,
    );

    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final channel in current)
        if (channel.id == channelId) updated else channel,
    ]);
  }

  Future<void> markAsRead(String channelId) async {
    await _repository.markChannelAsRead(channelId);
    final current = state.valueOrNull ?? [];
    state = AsyncData([
      for (final channel in current)
        if (channel.id == channelId)
          channel.copyWith(unreadCount: 0)
        else
          channel,
    ]);
  }

  Future<void> deleteChannel(String channelId) async {
    await _repository.deleteChannel(channelId);
    final current = state.valueOrNull ?? [];
    state = AsyncData(
      current.where((c) => !(c.id == channelId && !c.isDefault)).toList(),
    );
  }
}

final clubChannelsProvider =
    AsyncNotifierProvider.family<ClubChannelsNotifier, List<ClubChannel>, String>(
  ClubChannelsNotifier.new,
);