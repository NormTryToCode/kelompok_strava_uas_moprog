import 'package:kelompok_strava_uas_moprog/features/groups/models/challenge_model.dart';

List<Challenge> buildDummyChallenges() {
  final now = DateTime(2026, 11, 20);

  return [
    Challenge(
      id: 'ch_dec_400_min',
      title: 'December 400-Minute Momentum',
      summary: 'Complete 400 mins of activity in December — any sport counts!',
      description:
          'However you spend December, keep your momentum going. Stack 400 minutes across running, walking, cycling, or strength sessions before the month ends.\n\nEvery finisher unlocks a limited digital emblem in their trophy cabinet and community recognition across the club feed.',
      scope: ChallengeScope.community,
      metric: ChallengeMetric.movingMinutes,
      targetValue: 400,
      qualifyingSportIds: const ['all', 'running', 'cycling', 'walking', 'workout'],
      organizingClubId: 'club1',
      organizingClubName: 'Jakarta Sunrise Runners',
      organizingClubMembers: 1280,
      startDate: DateTime(2026, 12, 1),
      endDate: DateTime(2026, 12, 31),
      reward: const ChallengeReward(
        badgeCode: "400'",
        badgeTitle: 'December Momentum Finisher',
        description: "Earn the December 400' Digital Finisher Badge for your Trophy Vault.",
        points: 200,
      ),
      participantCount: 412,
      createdAt: now,
    ),
    Challenge(
      id: 'ch_ten_days_active',
      title: 'Ten Days Active Streak',
      summary: 'Log at least 10 minutes of activity on 10 separate days this month.',
      description:
          'Consistency beats intensity. Record at least 10 minutes of movement on 10 different days this month to build a sustainable training habit with your club.',
      scope: ChallengeScope.club,
      metric: ChallengeMetric.activeDays,
      targetValue: 10,
      qualifyingSportIds: const ['running', 'walking', 'hiking'],
      organizingClubId: 'club3',
      organizingClubName: 'Bandung Trail Society',
      organizingClubMembers: 640,
      startDate: DateTime(2026, 12, 1),
      endDate: DateTime(2026, 12, 31),
      reward: const ChallengeReward(
        badgeCode: '10x',
        badgeTitle: '10x Consistency Shield',
        description: 'Unlock the 10x Consistency Shield for your athlete profile.',
        points: 150,
      ),
      participantCount: 289,
      createdAt: now.subtract(const Duration(days: 1)),
    ),
    Challenge(
      id: 'ch_century_ride',
      title: 'Nusantara 250K Endurance Ride',
      summary: 'Accumulate 250 km on the saddle across road or virtual rides.',
      description:
          'Built for weekend pelotons and weekday commuters alike. Accumulate 250 kilometers of cycling before the month closes and compare your climbing split with fellow riders.',
      scope: ChallengeScope.club,
      metric: ChallengeMetric.distanceKm,
      targetValue: 250,
      qualifyingSportIds: const ['cycling', 'virtual-riding', 'e-biking'],
      organizingClubId: 'club2',
      organizingClubName: 'Nusantara Cycling Club',
      organizingClubMembers: 920,
      startDate: DateTime(2026, 12, 1),
      endDate: DateTime(2026, 12, 31),
      reward: const ChallengeReward(
        badgeCode: '250K',
        badgeTitle: 'Peloton Endurance Emblem',
        description: 'Earn the 250K Peloton Finisher Emblem.',
        points: 300,
      ),
      participantCount: 196,
      createdAt: now.subtract(const Duration(days: 2)),
    ),
    Challenge(
      id: 'ch_elevation_climb',
      title: 'Highlands 1,500m Climb',
      summary: 'Conquer 1,500 meters of total elevation gain across trail or road.',
      description:
          'Seek out the hills, bridges, and mountain trails. Every vertical meter counts toward your 1,500m summit goal.',
      scope: ChallengeScope.community,
      metric: ChallengeMetric.elevationMeters,
      targetValue: 1500,
      qualifyingSportIds: const ['running', 'hiking', 'cycling'],
      organizingClubId: 'club3',
      organizingClubName: 'Bandung Trail Society',
      organizingClubMembers: 640,
      startDate: DateTime(2026, 12, 1),
      endDate: DateTime(2026, 12, 31),
      reward: const ChallengeReward(
        badgeCode: '1.5K',
        badgeTitle: 'Summit Climber Trophy',
        description: 'Unlock the Summit Climber Trophy Badge.',
        points: 250,
      ),
      participantCount: 134,
      createdAt: now.subtract(const Duration(days: 3)),
    ),
  ];
}