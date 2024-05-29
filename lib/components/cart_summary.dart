import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';

class CartSummary extends StatelessWidget {
  final int totalAmount;

  const CartSummary({super.key, required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.orange.shade300,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('$totalAmount IQD', style: const TextStyle(fontSize: 17)),
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<StorageCubit>(context).checkout();
            },
            child: const Text('تسجيل الدفع',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
