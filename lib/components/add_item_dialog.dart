import 'package:flutter/material.dart';
import 'package:icemish/models/item_model.dart';

class AddItemDialog extends StatefulWidget {
  final Function(Item) onAdd;

  const AddItemDialog({super.key, required this.onAdd});

  @override
  AddItemDialogState createState() => AddItemDialogState();
}

class AddItemDialogState extends State<AddItemDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('إضافة منتج جديد'),
        content: Form(key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ادخل اسم المنتج';
                }
                return null;
              },
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'أسم المنتج'),
              ),
              TextFormField(validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ادخل سعر المنتج';
                }
                if (int.tryParse(value) == null) {
                  return 'سعر المنتج يجب أن يكون عدد';
                }
                return null;
              },
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'سعر المنتج'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('الغاء'),
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
            child: const Text('إضافة'),
          ),
        ],
      ),
    );
  }
}
