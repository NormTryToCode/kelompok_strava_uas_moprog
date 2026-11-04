import 'package:flutter/material.dart';

class ClubSport {
  final String id;
  final String name;
  final IconData icon;

  final String? subsports;

  const ClubSport({
    required this.id,
    required this.name,
    required this.icon,
    this.subsports,
  });

  static const allSports = ClubSport(
    id: 'all',
    name: 'All Sports',
    icon: Icons.layers_outlined,
  );

  static const option = <ClubSport>[
    allSports,
    ClubSport(id: "cycling", name: "Cycling", icon: Icons.directions_bike,
    subsports: 'HandCycle, E-Bike Ride, Gravel Ride, Virtual Ride, Velomobile, Mountain Bike Ride, E-Mountain Bike Ride, Ride'),
    ClubSport(id: "running", name: "Running", icon: Icons.directions_run,
    subsports: 'Run, Virtual Run, Wheelchair, Trail Run'),
    ClubSport(id: "triathlon", name: "Triathlon", icon: Icons.pool,
    subsports: 'All Run, All Ride, Swim'),
    ClubSport(id: 'alpine-skiing', name: 'Alpine Skiing', icon: Icons.downhill_skiing),
    ClubSport(id: 'backcountry-skiing', name: 'Backcountry Skiing', icon: Icons.downhill_skiing),
    ClubSport(id: 'nordic-skiing', name: 'Nordic Skiing', icon: Icons.nordic_walking),
    ClubSport(id: 'snowboarding', name: 'Snowboarding', icon: Icons.snowboarding),
    ClubSport(id: 'swimming', name: 'Swimming', icon: Icons.pool),
    ClubSport(id: 'walking', name: 'Walking', icon: Icons.directions_walk),
    ClubSport(id: 'hiking', name: 'Hiking', icon: Icons.hiking),
    ClubSport(id: 'rowing', name: 'Rowing', icon: Icons.rowing),
    ClubSport(id: 'yoga', name: 'Yoga', icon: Icons.self_improvement),
  ];
}

class ClubCreationModel {
  final ClubSport sport;

  const ClubCreationModel({this.sport = ClubSport.allSports});

  ClubCreationModel copyWith({ClubSport? sport}) {
    return ClubCreationModel(sport: sport ?? this.sport);
  }
}