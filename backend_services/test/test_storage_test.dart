import 'package:backend_services/src/test-data/test_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class AnObject {
  AnObject(this.stringValue, this.intValue);
  String stringValue = '';
  int intValue = 0;

  AnObject.fromJson(Map<String, dynamic> json)
      : stringValue = json['stringValue'],
        intValue = json['intValue'];

  Map<String, dynamic> toJson() => {
        'stringValue': stringValue,
        'intValue': intValue,
      };

  @override
  String toString() {
    return "stringValue: $stringValue\nintValue: $intValue";
  }
}

void main() async {
  var logger = Logger();

  test('save an object', () async {
    var storage = TestStorage();
    var filename = 'anotherFile.json';
    final obj = AnObject('an object', 5);

    storage.saveToPath(filename, obj);
    logger.i(storage);
  });

  test('save and doesExist an file', () async {
    var storage = TestStorage();
    var filename = 'anotherFile.json';

    storage.saveToPath(filename, "file content");
    final isExists = await storage.doesExist(filename);
    logger.i(isExists);
    expect(isExists, true);
  });

  test('save and load an object', () async {
    var storage = TestStorage();
    var filename = 'anotherFile.json';
    final obj = AnObject('an object', 5);

    storage.saveToPath(filename, obj);
    AnObject value = await storage.loadFromPath(filename, AnObject.fromJson);
    logger.i(value);
    expect(value.stringValue, 'an object');
    expect(value.intValue, 5);
    logger.i(storage);
  });

  test('doesExist, non-existant file', () async {
    var storage = TestStorage();
    var filename = 'nonexistantFile.json';

    final isExists = await storage.doesExist(filename);
    expect(false, isExists);
  });

  test('load file, non-existant file', () async {
    var storage = TestStorage();
    var filename = 'nonexistantFile.json';

    expectLater(
        () async => await storage.loadFromPath(filename, AnObject.fromJson),
        throwsA(isException));
  });
}
