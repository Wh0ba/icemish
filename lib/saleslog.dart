import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grouped_list/grouped_list.dart';
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
            return GroupedListView<LogTransaction, String>(
              elements: transactions,
              groupBy: (element) => getGroupByValue(element),
              groupSeparatorBuilder: (String value) => Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.all(Radius.circular(7))),
                child: ListTile(
                  trailing: Text(
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                      'Total: ${transactions.where((element) => getGroupByValue(element) == value).fold(0, (previousValue, element) => previousValue + element.totalPrice)} IQD'),
                  leading: Text(
                      textAlign: TextAlign.center,
                      '$value ${DateTime.parse(value).weekdayName()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      )),
                ),
              ),
              indexedItemBuilder: (context, transaction, index) {
                return Container(
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: logListTile(context, transaction, index),
                );
              },
            );
          },
        ),
      ),
    );
  }

  String getGroupByValue(LogTransaction transaction) {
    return '${transaction.timestamp.year}-${transaction.timestamp.month.toString().padLeft(2, '0')}-${transaction.timestamp.day.toString().padLeft(2, '0')}';
  }

  ListTile logListTile(
      BuildContext context, LogTransaction transaction, int index) {
    return ListTile(
        onLongPress: () {
          showDialog(
              context: context,
              builder: (_) => Directionality(
                    textDirection: TextDirection.rtl,
                    child: AlertDialog(
                      title: const Text('تأكيد الحذف',
                          style: TextStyle(fontSize: 25)),
                      content: const Text('هل تريد حذف هذه المبيعة؟',
                          style: TextStyle(fontSize: 16)),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text(
                              'لا',
                              style: TextStyle(fontSize: 20),
                            )),
                        TextButton(
                            onPressed: () async {
                              await context
                                  .read<StorageCubit>()
                                  .deleteLogTransaction(transaction);
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
        tileColor:
            index % 2 == 0 ? Colors.red.shade100 : Colors.orange.shade200,
        title: Text('${transaction.itemName} x ${transaction.itemCount}'),
        trailing: Text(
          '${transaction.totalPrice} IQD',
          style: const TextStyle(fontSize: 18),
        ),
        subtitle: Text(
          transaction.timestamp.toLocal().toString().substring(0, 16),
        ));
  }
}

extension DateTimeExtension on DateTime {
  String? weekdayName() {
    const Map<int, String> weekdayName = {
      1: "الاثنين",
      2: "الثلاثاء",
      3: "الاربعاء",
      4: "الخميس",
      5: "الجمعة",
      6: "السبت",
      7: "الاحد",
    };
    return weekdayName[weekday];
  }
}
