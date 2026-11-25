import 'package:kelompok_strava_uas_moprog/core/database/database_service.dart';
import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';

class ChannelRepository {
  static const _collection = 'channels';
  final _db = DatabaseService.instance;

  Future<List<ClubChannel>> getChannelsByClub(String clubId) async {
    final rows = await _db.getWhere(_collection, 'clubId', clubId);
    final clubChannels = rows.map(ClubChannel.fromJson).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));

    if (clubChannels.isEmpty) {
      final defaultChannel = ClubChannel.defaultAnnouncements(clubId);
      await _db.save(_collection, defaultChannel.id, defaultChannel.toJson());
      return [defaultChannel];
    }

    return clubChannels;
  }

  Future<ClubChannel?> _getById(String channelId) async {
    final rows = await _db.getWhere(_collection, 'id', channelId);
    if (rows.isEmpty) return null;
    return ClubChannel.fromJson(rows.first);
  }

  Future<ClubChannel> createChannel(ClubChannel channel) async {
    await _db.save(_collection, channel.id, channel.toJson());
    return channel;
  }

  Future<ClubChannel> sendMessage({
    required String channelId,
    required ChannelMessage message,
  }) async {
    final existing = await _getById(channelId);
    if (existing == null) {
      throw StateError('Channel not found: $channelId');
    }

    final updated = existing.copyWith(
      messages: [...existing.messages, message],
      unreadCount: message.isCurrentUser ? 0 : existing.unreadCount + 1,
    );
    await _db.save(_collection, updated.id, updated.toJson());
    return updated;
  }

  Future<void> markChannelAsRead(String channelId) async {
    final existing = await _getById(channelId);
    if (existing == null || existing.unreadCount == 0) return;

    final updated = existing.copyWith(unreadCount: 0);
    await _db.save(_collection, updated.id, updated.toJson());
  }

  Future<void> deleteChannel(String channelId) async {
    final existing = await _getById(channelId);
    if (existing == null || existing.isDefault) return;
    await _db.remove(_collection, channelId);
  }
}