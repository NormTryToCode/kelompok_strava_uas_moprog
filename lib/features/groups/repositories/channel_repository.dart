import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/repositories/local_json_store.dart';

class ChannelRepository {
  final _store = LocalJsonStore<ClubChannel>(
    fileName: 'channels.json',
    rootKey: 'channels',
    fromJson: ClubChannel.fromJson,
    toJson: (c) => c.toJson(),
  );

  Future<List<ClubChannel>> getChannelsByClub(String clubId) async {
    final all = await _store.readAll();
    final clubChannels = all.where((c) => c.clubId == clubId).toList();

    if (clubChannels.isEmpty) {
      final defaultChannel = ClubChannel.defaultAnnouncements(clubId);
      await _store.writeAll([...all, defaultChannel]);
      return [defaultChannel];
    }

    return clubChannels;
  }

  Future<ClubChannel> createChannel(ClubChannel channel) async {
    final all = await _store.readAll();
    await _store.writeAll([...all, channel]);
    return channel;
  }

  Future<ClubChannel> sendMessage({
    required String channelId,
    required ChannelMessage message,
  }) async {
    final all = await _store.readAll();
    ClubChannel? updatedChannel;

    final updatedList = [
      for (final channel in all)
        if (channel.id == channelId)
          updatedChannel = channel.copyWith(
            messages: [...channel.messages, message],
            unreadCount: message.isCurrentUser ? 0 : channel.unreadCount + 1,
          )
        else
          channel,
    ];

    if (updatedChannel == null) {
      throw StateError('Channel not found: $channelId');
    }

    await _store.writeAll(updatedList);
    return updatedChannel;
  }

  Future<void> markChannelAsRead(String channelId) async {
    final all = await _store.readAll();
    await _store.writeAll([
      for (final channel in all)
        if (channel.id == channelId) channel.copyWith(unreadCount: 0) else channel,
    ]);
  }

  Future<void> deleteChannel(String channelId) async {
    final all = await _store.readAll();
    await _store.writeAll(
      all.where((c) => !(c.id == channelId && !c.isDefault)).toList(),
    );
  }
}