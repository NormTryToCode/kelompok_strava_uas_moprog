import 'dart:convert';
import 'dart:io';

import 'package:kelompok_strava_uas_moprog/features/groups/models/channel_model.dart';
import 'package:path_provider/path_provider.dart';

class ChannelRepository {
  static const _fileName = 'channels.json';

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$_fileName');
  }

  Future<List<ClubChannel>> _readAll() async {
    final file = await _file();
    if (!await file.exists()) return [];

    try {
      final data = jsonDecode(await file.readAsString());
      final list = data is Map ? data['channels'] : null;
      if (list is! List) return [];
      return [
        for (final item in list)
          if (item is Map<String, dynamic>) ClubChannel.fromJson(item),
      ];
    } on FormatException {
      return [];
    }
  }

  Future<void> _writeAll(List<ClubChannel> channels) async {
    final file = await _file();
    final temp = File('${file.path}.tmp');
    final content = const JsonEncoder.withIndent('  ').convert({
      'channels': channels.map((c) => c.toJson()).toList(),
    });

    await temp.writeAsString(content, flush: true);
    await temp.rename(file.path);
  }

  Future<List<ClubChannel>> getChannelsByClub(String clubId) async {
    final all = await _readAll();
    final clubChannels = all.where((c) => c.clubId == clubId).toList();

    if (clubChannels.isEmpty) {
      final defaultChannel = ClubChannel.defaultAnnouncements(clubId);
      await _writeAll([...all, defaultChannel]);
      return [defaultChannel];
    }

    return clubChannels;
  }

  Future<ClubChannel> createChannel(ClubChannel channel) async {
    final all = await _readAll();
    await _writeAll([...all, channel]);
    return channel;
  }

  Future<ClubChannel> sendMessage({
    required String channelId,
    required ChannelMessage message,
  }) async {
    final all = await _readAll();
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

    await _writeAll(updatedList);
    return updatedChannel;
  }

  Future<void> markChannelAsRead(String channelId) async {
    final all = await _readAll();
    final updatedList = [
      for (final channel in all)
        if (channel.id == channelId)
          channel.copyWith(unreadCount: 0)
        else
          channel,
    ];
    await _writeAll(updatedList);
  }

  Future<void> deleteChannel(String channelId) async {
    final all = await _readAll();
    final updatedList = all
        .where((c) => !(c.id == channelId && !c.isDefault))
        .toList();
    await _writeAll(updatedList);
  }
}