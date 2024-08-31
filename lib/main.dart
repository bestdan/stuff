import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stuff/home/home_screen.dart';
import 'package:stuff/json_database.dart';
import 'package:stuff/notifiers/items_state_notifier.dart';
import 'package:stuff/notifiers/locations_state_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    JsonDatabase.initialize();
    final itemNotifier = ItemNotifier();
    itemNotifier.loadItems();
    final locationsNotifier = LocationsNotifier();
    locationsNotifier.loadLocations();

    return MultiProvider(
      providers: [
        Provider<ItemNotifier>(create: (_) => itemNotifier),
        Provider<LocationsNotifier>(create: (_) => locationsNotifier),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const HomeScreen(),
      ),
    );
  }
}
