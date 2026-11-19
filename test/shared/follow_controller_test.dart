import 'package:flutter_test/flutter_test.dart';
import 'package:kelompok_strava_uas_moprog/shared/controllers/follow_controller.dart';

void main() {
  test('toggle menambah lalu menghapus id', () {
    final controller = FollowController();

    controller.toggle('a');
    expect(controller.isFollowing('a'), isTrue);
    expect(controller.followingCount, 1);

    controller.toggle('a');
    expect(controller.isFollowing('a'), isFalse);
    expect(controller.followingCount, 0);
  });

  test('toggle memberi tahu listener', () {
    final controller = FollowController();
    var calls = 0;
    controller.addListener(() => calls++);

    controller.toggle('a');

    expect(calls, 1);
  });
}