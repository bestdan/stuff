import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:stuff/home/widgets/item_row.dart';
import 'package:stuff/item/add_item_screen.dart';
import 'package:stuff/item/item.dart';
import 'package:stuff/json_database.dart';
import 'package:stuff/notifiers/items_state_notifier.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final context = useContext();

    final items =
        context.select<ItemNotifier, List<Item>>((notifier) => notifier.items);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Where\'s my stuff'),
        leading: Text(DateTime.now().toIso8601String()),
        actions: [
          IconButton(
            onPressed: () async {
              await JsonDatabase.clearDatabase();
              JsonDatabase.initialize();
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Items in database:'),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('Add an item to get started'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ItemCard(item: items[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const SizedBox(height: 10),
          FloatingActionButton(
            onPressed: () async => await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewItemScreen()),
            ),
            tooltip: 'Add Item',
            child: const Icon(Icons.playlist_add),
          ),
        ],
      ),
    );
  }
}
