import 'package:flutter/foundation.dart';

class FollowController extends ChangeNotifier {
  FollowController({Set<String>? initial}) : _following = {...?initial};

  static final FollowController instance = FollowController();

  final Set<String> _following;

  int get followingCount => _following.length;

  bool isFollowing(String id) => _following.contains(id);

  void toggle(String id) {
    if (!_following.remove(id)) {
      _following.add(id);
    }
    notifyListeners();
  }
}