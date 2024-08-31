import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:provider/provider.dart';
import 'package:stuff/item/item.dart';
import 'package:stuff/models/location.dart';
import 'package:stuff/notifiers/items_state_notifier.dart';

class NewItemScreen extends HookWidget {
  const NewItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final name = useState<String?>(null);
    final description = useState<String?>(null);
    final location = useState<Location?>(null);
    final context = useContext();

    Future<void> submitForm() async {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        final nextItemId = context.read<ItemNotifier>().nextItemId();
        final locationId = context
            .read<ItemNotifier>()
            .nextLocationId(); //TOOD(dan): need to make run off add location

        final newItem = Item(
          id: nextItemId,
          displayName: name.value ?? 'New item',
          description: description.value ?? "New descripton",
          locationId: locationId,
          lastUpdated: DateTime.now(),
        );

        if (!context.mounted) return;

        // Use ChangeNotifierProvider to access ItemNotifier
        context.read<ItemNotifier>().addItem(newItem);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Item added with ID: ${newItem.id}')),
        );
        Navigator.pop(context);
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Display Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a display name';
                  }
                  return null;
                },
                onSaved: (value) => name.value = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) => description.value = value!,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
