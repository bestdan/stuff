import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:stuff/home/home_loading.dart';
import 'package:stuff/home/home_screen.dart';
import 'package:stuff/json_database.dart';
import 'package:stuff/notifiers/items_state_notifier.dart';
import 'package:stuff/notifiers/locations_state_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends HookWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final isInitialized = useState(false);

    useEffect(() {
      Future<void> initialize() async {
        isInitialized.value = await JsonDatabase.initialize();
      }

      initialize();
      return null;
    }, []);

    return MultiProvider(
      providers: [
        Provider<ItemNotifier>(create: (_) => ItemNotifier()),
        Provider<LocationsNotifier>(create: (_) => LocationsNotifier()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: isInitialized.value
            ? const HomeScreen()
            : const HomeLoadingScreen(),
      ),
    );
  }
}
