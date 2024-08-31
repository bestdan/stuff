import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_state_notifier/flutter_state_notifier.dart';
import 'package:stuff/item/item.dart';
import 'package:stuff/json_database.dart';

class ItemNotifier extends StateNotifier<List<Item>> {
  ItemNotifier() : super(<Item>[]) {
    loadItems();
  }

  List<Item> get items => state;

  Future<void> loadItems() async {
    final items = await JsonDatabase.getItems();
    state = items;
  }

  int nextItemId() {
    return items.fold<int>(0, (i, item) => max(i, item.id));
  }

  int nextLocationId() {
    return items.fold<int>(0, (i, item) => max(i, item.id));
  }

  Future<void> addItem(Item item) async {
    await JsonDatabase.addItem(item);
    state = [...state, item];
  }

  Future<void> updateItem(Item item) async {
    await JsonDatabase.updateItem(item);
    state = state.map((i) => i.id == item.id ? item : i).toList();
  }

  Future<void> deleteItem(int id) async {
    await JsonDatabase.deleteItem(id);
    state = state.where((item) => item.id != id).toList();
  }

  static StateNotifierProvider<ItemNotifier, List<Item>> provide(
      {required Widget child}) {
    return StateNotifierProvider<ItemNotifier, List<Item>>(
      create: (_) => ItemNotifier(),
      child: child,
    );
  }
}
