import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:kelompok_strava_uas_moprog/features/groups/tabs/clubs/models/club_creation_model.dart';

class LocationSearchException implements Exception {
  final String message;

  const LocationSearchException(this.message);

  @override
  String toString() => message;
}

class LocationSearch {
  LocationSearch({http.Client? client})
      : _client = client ?? http.Client();

  final http.Client _client;

  static const _host = 'photon.komoot.io';

  Future<List<ClubLocation>> search(String query, {int limit = 8}) async {
    final uri = Uri.https(_host, '/api/', {
      'q': query,
      'limit': '$limit',
      'lang': 'en',
    });

    try {
      final response = await _client
          .get(uri, headers: {'User-Agent': 'kelompok_strava_uas_moprog'})
          .timeout(const Duration(seconds: 8));

      if (response.statusCode != 200) {
        throw LocationSearchException('Search failed (${response.statusCode})');
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final features = (data['features'] as List?) ?? const [];

      final seen = <String>{};
      final results = <ClubLocation>[];
      for (final feature in features) {
        final location = _parse(feature);
        if (location == null) continue;
        if (seen.add('${location.name}|${location.detail}')) {
          results.add(location);
        }
      }
      return results;
    } on LocationSearchException {
      rethrow;
    } on Object {
      throw const LocationSearchException('Could not reach the search service');
    }
  }

  ClubLocation? _parse(dynamic feature) {
    if (feature is! Map) return null;
    final props = feature['properties'];
    if (props is! Map) return null;

    final name = _text(props['name']);
    if (name.isEmpty) return null;

    double? latitude;
    double? longitude;
    final geometry = feature['geometry'];
    if (geometry is Map && geometry['coordinates'] is List) {
      final coords = geometry['coordinates'] as List;
      if (coords.length >= 2 && coords[0] is num && coords[1] is num) {
        longitude = (coords[0] as num).toDouble();
        latitude = (coords[1] as num).toDouble();
      }
    }

    final parts = <String>[];
    for (final value in [
      _text(props['city']).isNotEmpty ? props['city'] : props['county'],
      props['state'],
      props['country'],
    ]) {
      final text = _text(value);
      if (text.isNotEmpty && text != name && !parts.contains(text)) {
        parts.add(text);
      }
    }

    return ClubLocation(
      name: name,
      detail: parts.join(', '),
      latitude: latitude,
      longitude: longitude,
    );
  }

  String _text(dynamic value) => value is String ? value.trim() : '';

  void dispose() => _client.close();
}
