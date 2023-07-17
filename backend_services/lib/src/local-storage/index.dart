import 'dart:convert';
import 'dart:io';

import 'package:backend_services/interfaces/json_storage.dart';
import 'package:path/path.dart' as p;

class LocalStorageService implements JsonStorage {
  final String basePath;

  LocalStorageService(this.basePath);

  @override
  Future<bool> doesExist(String filename) async {
    final path = p.join(basePath, filename);
    final file = File(path);
    return await file.exists();
  }

  @override
  Future<T> loadFromPath<T>(
      String filename, T Function(Map<String, dynamic>) fromJson) async {
    if (!await doesExist(filename)) {}

    final path = p.join(basePath, filename);
    final file = File(path);

    String contents = await file.readAsString();
    var jsonData = jsonDecode(contents);
    return fromJson(jsonData);
  }

  @override
  Future<void> saveToPath(String filename, data) async {
    final path = p.join(basePath, filename);
    final jsonFile = File(path);
    var json = jsonEncode(data);
    await jsonFile.writeAsString(json, mode: FileMode.writeOnly);
  }
}
