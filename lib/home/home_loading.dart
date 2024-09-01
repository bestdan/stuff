import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class HomeLoadingScreen extends HookWidget {
  const HomeLoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final context = useContext();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Where\'s my stuff'),
        leading: Expanded(child: Text(DateTime.now().toIso8601String())),
      ),
      body: const Center(
        child: Text('Loading'),
      ),
    );
  }
}
