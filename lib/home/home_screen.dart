import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:stuff/home/widgets/item_row.dart';
import 'package:stuff/item/add_item_screen.dart';
import 'package:stuff/item/item.dart';
import 'package:stuff/json_database.dart';
import 'package:stuff/models/location.dart';
import 'package:stuff/notifiers/items_state_notifier.dart';
import 'package:stuff/notifiers/locations_state_notifier.dart';

class HomeScreen extends HookWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final context = useContext();

    final items = useState<List<Item>>([]);
    final locations = useState<List<Location>>([]);
    final db = useState<String>('Loading');

    items.value =
        context.select<ItemNotifier, List<Item>>((notifier) => notifier.items);

    locations.value = context.select<LocationsNotifier, List<Location>>(
        (notifier) => notifier.locations);

    useEffect(() {
      Future<void> fetchDatabase() async {
        final result = await JsonDatabase.vomitDatabase();
        db.value = result ?? 'Loading';
      }

      fetchDatabase();
      return null;
    }, []);

    final isLoading = items.value.isEmpty || locations.value.isEmpty;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(onPressed: () {}, icon: const Icon(Icons.menu)),
        title: const SearchBox(),
        actions: [
          IconButton(
            onPressed: () async {
              await JsonDatabase.clearDatabase();
              await JsonDatabase.initialize();
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
              child: isLoading
                  ? const Center(child: Text('Add an item to get started'))
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 2, horizontal: 2),
                      itemCount: items.value.length,
                      itemBuilder: (context, index) {
                        return ItemCard(item: items.value[index]);
                      },
                    ),
            ),
            Expanded(child: Text(db.value)),
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

class SearchBox extends StatelessWidget {
  const SearchBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        decoration: InputDecoration(
          hintText: '🔍',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          filled: true,
          contentPadding: const EdgeInsets.all(8),
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
