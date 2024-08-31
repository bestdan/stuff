import 'package:flutter/material.dart';
import 'package:stuff/db/db.dart';

class Item {
  final int id;
  final String displayName;
  final String description;
  final Image? image;
  final String? qrCode;
  final int locationId;
  final DateTime lastUpdated;

  Item({
    required this.id,
    required this.displayName,
    required this.description,
    required this.locationId,
    this.image,
    this.qrCode,
    required this.lastUpdated,
  });

  factory Item.example() {
    return Item(
      id: 1,
      displayName: 'Example item',
      description: 'Just a default item',
      locationId: 1,
      lastUpdated: DateTime.now(),
    );
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      id: map['id'] as int,
      displayName: map['name'] as String,
      description: map['description'] as String,
      locationId: map['locationId'] as int,
      lastUpdated: DateTime.parse(map['lastUpdated'] as String),
      // Note: image, qrCode, and location are not included in the current database schema
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': displayName,
      'description': description,
      'lastUpdated': lastUpdated.toIso8601String(),
      // Optional fields
      if (qrCode != null) 'qrCode': qrCode,
      'locationId': locationId,
      // Note: 'image' is not included as it's not easily serializable to JSON
    };
  }

  Future<int> insertIntoDatabase() async {
    final db = await DatabaseHelper.instance.database;
    return await db.insert('items', {
      'name': displayName,
      'description': description,
      // Note: We're not inserting 'image', 'qrCode', or 'location' as they're not in the current table schema
      'lastUpdated': lastUpdated.toIso8601String(),
    });
  }
}
