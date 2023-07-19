abstract class JsonStorage {
  Future<bool> doesExist(String filename);
  Future<void> saveToPath(String filename, dynamic data);
  Future<T> loadFromPath<T>(
      String filename, T Function(Map<String, dynamic> json) fromJson);
}
