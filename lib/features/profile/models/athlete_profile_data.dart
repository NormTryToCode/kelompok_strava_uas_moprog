class AthleteProfileData {
  final String firstName;
  final String lastName;
  final String city;
  final String country;
  final String primarySport;
  final String bio;
  final String birthDate;
  final String gender;
  final String weightKg;
  final bool googleFitConnected;

  const AthleteProfileData({
    required this.firstName,
    required this.lastName,
    required this.city,
    required this.country,
    required this.primarySport,
    required this.bio,
    required this.birthDate,
    required this.gender,
    required this.weightKg,
    this.googleFitConnected = false,
  });

  String get fullName {
    final trimmedFirst = firstName.trim();
    final trimmedLast = lastName.trim();
    if (trimmedFirst.isEmpty && trimmedLast.isEmpty) {
      return 'Atlet Strava';
    }
    if (trimmedLast.isEmpty) return trimmedFirst;
    if (trimmedFirst.isEmpty) return trimmedLast;
    return '$trimmedFirst $trimmedLast';
  }
}