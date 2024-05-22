import 'package:flutter/material.dart';
import 'package:icemish/models/item_model.dart';

class AddItemDialog extends StatefulWidget {
  final Function(Item) onAdd;

  const AddItemDialog({super.key, required this.onAdd});

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add New Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Item Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Item Price'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            final name = _nameController.text;
            final price = int.tryParse(_priceController.text);
            if (name.isNotEmpty && price != null) {
              widget.onAdd(Item(name: name, price: price));
              Navigator.of(context).pop();
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
