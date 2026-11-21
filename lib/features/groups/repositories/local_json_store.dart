import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class LocalJsonStore<T> {
  final String fileName;
  final String rootKey;
  final T Function(Map<String, dynamic> json) fromJson;
  final Map<String, dynamic> Function(T item) toJson;

  const LocalJsonStore({
    required this.fileName,
    required this.rootKey,
    required this.fromJson,
    required this.toJson,
  });

  Future<File> _file() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}${Platform.pathSeparator}$fileName');
  }

  Future<List<T>> readAll() async {
    final file = await _file();
    if (!await file.exists()) return [];

    try {
      final data = jsonDecode(await file.readAsString());
      final list = data is Map ? data[rootKey] : null;
      if (list is! List) return [];
      return [
        for (final item in list)
          if (item is Map<String, dynamic>) fromJson(item),
      ];
    } on FormatException {
      return [];
    }
  }

  Future<void> writeAll(List<T> items) async {
    final file = await _file();
    final temp = File('${file.path}.tmp');
    final content = const JsonEncoder.withIndent('  ').convert({
      rootKey: items.map(toJson).toList(),
    });

    await temp.writeAsString(content, flush: true);
    await temp.rename(file.path);
  }
}