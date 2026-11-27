import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kelompok_strava_uas_moprog/features/relationship/repositories/chat_repository.dart';

final unreadDmCountProvider = StreamProvider.autoDispose<int>(
  (ref) => ChatRepository.instance.watchUnreadCount(),
);