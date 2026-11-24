import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

class LocationPhotoQuery {
  final double? latitude;
  final double? longitude;
  final String placeName;
  final String? detail;

  const LocationPhotoQuery({
    this.latitude,
    this.longitude,
    required this.placeName,
    this.detail,
  });

  bool get hasCoordinates => latitude != null && longitude != null;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationPhotoQuery &&
        other.latitude?.toStringAsFixed(3) ==
            latitude?.toStringAsFixed(3) &&
        other.longitude?.toStringAsFixed(3) ==
            longitude?.toStringAsFixed(3) &&
        other.placeName == placeName &&
        other.detail == detail;
  }

  @override
  int get hashCode => Object.hash(
        latitude?.toStringAsFixed(3),
        longitude?.toStringAsFixed(3),
        placeName,
        detail,
      );
}

class LocationPhotoService {
  LocationPhotoService._();

  static const _headers = {
    'User-Agent': 'kelompok_strava_uas_moprog/1.0 (Flutter UAS App)',
  };

  static const _blockedKeywords = [
    'logo',
    'flag',
    'coat_of_arms',
    'emblem',
    'map',
    'locator',
    'blank',
    'icon',
    'diagram',
    'seal',
    '.svg',
  ];

  static Future<String?> fetchAreaPhoto(LocationPhotoQuery query) async {
    // 1. Cari foto landmark/wilayah terdekat berdasarkan koordinat peta (EN -> ID)
    if (query.hasCoordinates) {
      final enGeo = await _geoSearch(
        host: 'en.wikipedia.org',
        lat: query.latitude!,
        lng: query.longitude!,
      );
      if (enGeo != null) return enGeo;

      final idGeo = await _geoSearch(
        host: 'id.wikipedia.org',
        lat: query.latitude!,
        lng: query.longitude!,
      );
      if (idGeo != null) return idGeo;
    }

    // 2. Fallback: cari berdasarkan nama tempat / kota
    final terms = <String>[
      query.placeName.trim(),
      if (query.detail != null && query.detail!.trim().isNotEmpty)
        query.detail!.split(',').first.trim(),
    ].where((t) => t.isNotEmpty && t.toLowerCase() != 'virtual').toSet();

    for (final term in terms) {
      final enText = await _textSearch(host: 'en.wikipedia.org', query: term);
      if (enText != null) return enText;

      final idText = await _textSearch(host: 'id.wikipedia.org', query: term);
      if (idText != null) return idText;
    }

    return null;
  }

  static Future<String?> _geoSearch({
    required String host,
    required double lat,
    required double lng,
  }) async {
    final uri = Uri.https(host, '/w/api.php', {
      'action': 'query',
      'generator': 'geosearch',
      'ggscoord': '$lat|$lng',
      'ggsradius': '10000',
      'ggslimit': '12',
      'prop': 'pageimages',
      'piprop': 'thumbnail',
      'pithumbsize': '900',
      'pilicense': 'any',
      'format': 'json',
    });

    return _requestFirstValidThumbnail(uri);
  }

  static Future<String?> _textSearch({
    required String host,
    required String query,
  }) async {
    final uri = Uri.https(host, '/w/api.php', {
      'action': 'query',
      'generator': 'search',
      'gsrsearch': query,
      'gsrlimit': '6',
      'prop': 'pageimages',
      'piprop': 'thumbnail',
      'pithumbsize': '900',
      'pilicense': 'any',
      'format': 'json',
    });

    return _requestFirstValidThumbnail(uri);
  }

  static Future<String?> _requestFirstValidThumbnail(Uri uri) async {
    try {
      final response = await http
          .get(uri, headers: _headers)
          .timeout(const Duration(seconds: 6));
      if (response.statusCode != 200) return null;

      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return null;

      final queryMap = decoded['query'];
      if (queryMap is! Map) return null;

      final pages = queryMap['pages'];
      if (pages is! Map) return null;

      final sorted = [
        for (final value in pages.values)
          if (value is Map) value,
      ]..sort((a, b) {
          final ia = (a['index'] as num?)?.toInt() ?? 999;
          final ib = (b['index'] as num?)?.toInt() ?? 999;
          return ia.compareTo(ib);
        });

      for (final page in sorted) {
        final thumb = page['thumbnail'];
        if (thumb is! Map) continue;
        final source = thumb['source'] as String?;
        if (source == null || source.isEmpty) continue;
        if (_isUsablePhoto(source, thumb)) return source;
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  static bool _isUsablePhoto(String url, Map thumb) {
    final lower = url.toLowerCase();
    for (final blocked in _blockedKeywords) {
      if (lower.contains(blocked)) return false;
    }
    final width = (thumb['width'] as num?)?.toInt() ?? 0;
    final height = (thumb['height'] as num?)?.toInt() ?? 0;
    return width >= 240 && height >= 140;
  }
}

final locationPhotoProvider =
    FutureProvider.family<String?, LocationPhotoQuery>((ref, query) {
  return LocationPhotoService.fetchAreaPhoto(query);
});