import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuff/item/item.dart';
import 'package:stuff/notifiers/locations_state_notifier.dart';

class ItemCard extends StatelessWidget {
  final Item item;

  const ItemCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final location =
        context.read<LocationsNotifier>().location(item.locationId);

    return Card(
        child: Column(children: [
      const SizedBox(height: 1),
      ListTile(
        title: Text(item.displayName),
        subtitle: Text(item.description),
        trailing: Text(location?.displayName ?? 'No matching location'),
        tileColor: const Color.fromARGB(255, 123, 206, 244),
      ),
      const SizedBox(height: 1),
    ]));
  }
}
