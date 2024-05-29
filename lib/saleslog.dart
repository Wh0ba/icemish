import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';
import 'package:icemish/models/transaction_model.dart';

class SalesLog extends StatelessWidget {
  const SalesLog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'المبيعات',
            style: TextStyle(fontFamily: 'kufi'),
          ),
          centerTitle: true,
          elevation: 2),
      body: FutureBuilder<List<Transaction>>(
        future: context.read<StorageCubit>().getTransactions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final transactions = snapshot.data ?? [];
          if (transactions.isEmpty) {
            return const Center(
                child: Opacity(
              opacity: 0.4,
              child: Text('لا يوجد مبيعات',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  )),
            ));
          }
          return ListView.builder(
            itemCount: transactions.length,
            itemBuilder: (context, index) {
              final transaction = transactions[index];
              return Container(
                margin: const EdgeInsets.only(
                  bottom: 10,
                ),
                child: ListTile(
                    tileColor: index % 2 == 0
                        ? Colors.red.shade100
                        : Colors.orange.shade200,
                    title: Text(
                        '${transaction.itemName} x ${transaction.itemCount}'),
                    trailing: Text(
                      '${transaction.totalPrice} IQD',
                      style: const TextStyle(fontSize: 18),
                    ),
                    subtitle: Text(
                      transaction.timestamp
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                    )),
              );
            },
          );
        },
      ),
    );
  }
}
