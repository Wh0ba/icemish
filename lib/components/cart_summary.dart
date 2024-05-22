import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';

class CartSummary extends StatelessWidget {
  final int totalAmount;

  const CartSummary({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$totalAmount IQD'),
          ElevatedButton(
            onPressed: () {
              //get items and thier count
              print(BlocProvider.of<StorageCubit>(context).state);
            },
            child: const Text('Checkout'),
          ),
        ],
      ),
    );
  }
}
