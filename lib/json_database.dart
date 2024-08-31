import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:stuff/item/item.dart';
import 'package:stuff/models/location.dart';

class JsonDatabase {
  static const String _fileName = 'stuff_database.json';

  static Map<String, dynamic> get _defaultData =>
      {'items': [], 'locations': []};

  static Future<bool> get _fileExists async {
    final file = await _localFile;
    return await file.exists();
  }

  static Future<File> get _localFile async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  static Future<void> initialize() async {
    final file = await _localFile;
    if (!await file.exists()) {
      await file.writeAsString(json.encode({
        'items': [Item.example().toMap()],
        'locations': [Location(id: 1, displayName: 'Home').toMap()]
      }));
    }
  }

  static Future<void> clearDatabase() async {
    if (await _fileExists) {
      final file = await _localFile;
      await file.delete();
    }
  }

  static Future<Map<String, dynamic>> _readDatabase() async {
    if (!await _fileExists) {
      return _defaultData;
    }
    try {
      final file = await _localFile;
      final contents = await file.readAsString();
      return json.decode(contents);
    } catch (e) {
      print('Error reading database: $e');
      return {'items': [], 'locations': []};
    }
  }

  static Future<void> _writeDatabase(Map<String, dynamic> data) async {
    if (!await _fileExists) {
      return;
    }
    try {
      final file = await _localFile;
      await file.writeAsString(json.encode(data));
    } catch (e) {
      print('Error writing to database: $e');
    }
  }

  static Future<List<Item>> getItems() async {
    final data = await _readDatabase();
    return (data['items'] as List).map((item) => Item.fromMap(item)).toList();
  }

  static Future<List<Location>> getLocations() async {
    final data = await _readDatabase();
    return (data['locations'] as List)
        .map((location) => Location.fromMap(location))
        .toList();
  }

  static Future<void> addItem(Item item) async {
    final data = await _readDatabase();

    data['items'].add(item.toMap());
    await _writeDatabase(data);
  }

  static Future<void> updateItem(Item item) async {
    final data = await _readDatabase();
    final index = (data['items'] as List).indexWhere((i) => i['id'] == item.id);
    if (index != -1) {
      data['items'][index] = item.toMap();
      await _writeDatabase(data);
    }
  }

  static Future<void> deleteItem(int id) async {
    final data = await _readDatabase();
    data['items'].removeWhere((item) => item['id'] == id);
    await _writeDatabase(data);
  }

  static Future<void> addLocation(Location location) async {
    final data = await _readDatabase();
    if (!data['locations'].contains(location)) {
      data['locations'].add(location);
      await _writeDatabase(data);
    }
  }

  static Future<void> updateLocation(Location location) async {
    final data = await _readDatabase();
    final index =
        (data['location'] as List).indexWhere((i) => i['id'] == location.id);
    if (index != -1) {
      data['locations'][index] = location.toMap();
      await _writeDatabase(data);
    }
  }

  static Future<void> deleteLocation(String location) async {
    final data = await _readDatabase();
    data['locations'].remove(location);
    await _writeDatabase(data);
  }
}
