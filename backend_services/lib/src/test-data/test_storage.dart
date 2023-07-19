import 'dart:convert';
import 'dart:io';

import 'package:backend_services/interfaces/json_storage.dart';

class TestStorage implements JsonStorage {
  Map<String, String> jsonAtPath = {};

  @override
  Future<bool> doesExist(String filename) async {
    return jsonAtPath.containsKey(filename);
  }

  @override
  Future<T> loadFromPath<T>(
      String path, T Function(Map<String, dynamic>) fromJson) async {
    if (!await doesExist(path)) {
      throw PathNotFoundException(path, OSError("Nothing stored at '$path'."));
    }

    final contents = jsonAtPath[path];
    final data = jsonDecode(contents ?? "");
    return fromJson(data);
  }

  @override
  Future<void> saveToPath(String path, dynamic data) async {
    jsonAtPath[path] = jsonEncode(data);
  }

  @override
  String toString() {
    return jsonAtPath.keys.map((k) => "$k: ${jsonAtPath[k]}").join('\n');
  }
}
