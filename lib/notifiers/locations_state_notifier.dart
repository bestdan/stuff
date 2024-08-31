import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:stuff/json_database.dart';
import 'package:stuff/models/location.dart';

class LocationsNotifier extends StateNotifier<List<Location>> {
  LocationsNotifier() : super(<Location>[]) {
    loadLocations();
  }

  List<Location> get locations => state;

  Location location(int locationId) {
    return state.firstWhere((location) => location.id == locationId);
  }

  Future<void> loadLocations() async {
    final locations = await JsonDatabase.getLocations();
    state = locations;
  }

  int nextLocationId() {
    return locations.fold<int>(0, (i, location) => max(i, location.id));
  }

  Future<void> addLocation(Location location) async {
    await JsonDatabase.addLocation(location);
    state = [...state, location];
  }

  Future<void> updateLocation(Location location) async {
    await JsonDatabase.updateLocation(location);
    state = state.map((i) => i.id == location.id ? location : i).toList();
  }

  Future<void> deleteItem(int id) async {
    await JsonDatabase.deleteItem(id);
    state = state.where((item) => item.id != id).toList();
  }

  static StateNotifierProvider<LocationsNotifier, List<Location>> provide(
      {required Widget child}) {
    return StateNotifierProvider<LocationsNotifier, List<Location>>(
      create: (_) => LocationsNotifier(),
      child: child,
    );
  }
}
