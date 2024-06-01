import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';
import 'package:icemish/models/transaction_model.dart';

class SalesLog extends StatefulWidget {
  const SalesLog({super.key});

  @override
  State<SalesLog> createState() => _SalesLogState();
}

class _SalesLogState extends State<SalesLog> {
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
      body: RefreshIndicator(
        onRefresh: () {
          setState(() {});
          return Future.value();
        },
        child: FutureBuilder<List<LogTransaction>>(
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
                child: Text('لا توجد مبيعات',
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
                      onLongPress: () {
                        showDialog(
                            context: context,
                            builder: (_) => Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: AlertDialog(
                                    title: const Text('تأكيد الحذف',
                                        style: TextStyle(fontSize: 25)),
                                    content: const Text(
                                        'هل تريد حذف هذه المبيعة؟',
                                        style: TextStyle(fontSize: 16)),
                                    actions: [
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: const Text(
                                            'لا',
                                            style: TextStyle(fontSize: 20),
                                          )),
                                      TextButton(
                                          onPressed: () async {
                                            await context
                                                .read<StorageCubit>()
                                                .deleteLogTransaction(
                                                    transaction);
                                            if (context.mounted) {
                                              Navigator.of(context).pop();
                                            }
                                            setState(() {});
                                          },
                                          child: const Text(
                                            'نعم',
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold),
                                          )),
                                    ],
                                  ),
                                ));
                      },
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
      ),
    );
  }
}
