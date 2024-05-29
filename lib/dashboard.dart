import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/components/add_item_dialog.dart';
import 'package:icemish/components/item_counter.dart';
import 'package:icemish/cubits/storage_cubit.dart';
import 'package:icemish/models/item_model.dart';

import 'components/cart_summary.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              context.read<StorageCubit>().clear();
            },
            icon: const Icon(Icons.refresh)),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => showDialog(
              context: context,
              builder: (_) => AddItemDialog(
                onAdd: (item) => context.read<StorageCubit>().addItem(item),
              ),
            ),
          ),
        ],
        elevation: 1,
        title: const Text('مشمشة', style: TextStyle(fontFamily: 'kufi')),
        centerTitle: true,
      ),
      body: Column(
        children: [
          BlocBuilder<StorageCubit, List<Item>>(
            builder: (context, items) {
              return Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    return ItemCounter(item: items[index]);
                  },
                ),
              );
            },
          ),
          const Spacer(),
          BlocBuilder<StorageCubit, List<Item>>(builder: (context, items) {
            return CartSummary(
                totalAmount: items.fold(0, (a, b) => a + (b.price * b.count)));
          })
        ],
      ),
    );
  }
}
