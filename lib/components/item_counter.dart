import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';
import 'package:icemish/models/item_model.dart';
import '../cubits/item_cubit.dart';

class ItemCounter extends StatelessWidget {
  final Item item;

  const ItemCounter({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ItemCubit(context.read<StorageCubit>(), item),
      child: BlocBuilder<ItemCubit, int>(
        builder: (context, count) {
          return Container(
              margin: const EdgeInsets.all(15.0),
              padding: const EdgeInsets.only(left: 15, top: 15, bottom: 15),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                leading: Text('$count',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                title: Text(item.name),
                subtitle: Text('${item.price} IQD'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () => context.read<ItemCubit>().decrement(),
                    ),
                    const SizedBox(width: 25),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.read<ItemCubit>().increment(),
                    ),
                  ],
                ),
              ));
        },
      ),
    );
  }
}
