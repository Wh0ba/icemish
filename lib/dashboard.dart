import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/auth/auth.dart';
import 'package:icemish/auth_pages/sign_in_page.dart';
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
              showDialog(
                  context: context,
                  builder: (_) => Directionality(
                        textDirection: TextDirection.rtl,
                        child: AlertDialog(
                            title: const Text('تسجيل خروج'),
                            content: const Text('هل تريد تسجيل الخروج؟'),
                            actions: [
                              TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('لا',
                                      style: TextStyle(fontSize: 20))),
                              TextButton(
                                  onPressed: () async {
                                    await signOut();

                                    if (context.mounted) {
                                      Navigator.of(context).popUntil(
                                        (route) => route.isFirst,
                                      );
                                      
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  const SignInPage()));
                                    }
                                  },
                                  child: const Text('نعم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20,
                                          color: Colors.red))),
                            ]),
                      ));
            },
            icon: const Icon(Icons.logout)),
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
