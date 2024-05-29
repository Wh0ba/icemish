import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/models/item_model.dart';
import 'package:icemish/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String itemPrefsKey = 'items_prefs_key';
const String transactionsPrefsKey = 'transactions_prefs_key';

class StorageCubit extends Cubit<List<Item>> {
  StorageCubit() : super([]) {
    _loadItems();
  }

  void _loadItems() async {
    final prefs = await SharedPreferences.getInstance();
    final items = prefs.getStringList(itemPrefsKey) ?? [];
    if (items.isNotEmpty) {
      final parsedItems = items.map((i) => Item.fromMap(jsonDecode(i)));
      emit(parsedItems.toList());
    }
  }

  void addItem(Item item) {
    if (state.any((i) => i.name == item.name)) {
      return;
    }
    emit([...state, item]);
    saveItems();
  }

  void updateItem(Item item) {
    final index = state.indexWhere((i) => i.name == item.name);
    if (index == -1) {
      return;
    }
    final updatedState = List<Item>.from(state);
    updatedState[index] = item;
    emit(updatedState);
    saveItems();
  }

  void removeItem(Item item) {
    if (!state.any((i) => i.name == item.name)) {
      return;
    }
    final updatedState = state.where((i) => i.name != item.name).toList();
    emit(updatedState);
    saveItems();
  }

  void clear() {
    final updatedState = state.map((item) {
      item.count = 0;
      return item;
    }).toList();
    emit(updatedState);
    saveItems();
  }

  void saveItems() async {
    final items = state.map((i) => jsonEncode(i.toMap())).toList();
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(itemPrefsKey, items);
  }


  void checkout() async {
    final transactions = await _loadTransactions();
    final newTransactions = state.where((item) => item.count > 0).map((item) {
      return Transaction(
        itemName: item.name,
        itemCount: item.count,
        totalPrice: item.count * item.price,
        timestamp: DateTime.now(),
      );
    }).toList();

    final updatedTransactions = [...transactions, ...newTransactions];
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(transactionsPrefsKey,
        updatedTransactions.map((t) => jsonEncode(t.toMap())).toList());

    clear();
  }

  Future<List<Transaction>> _loadTransactions() async {
    final prefs = await SharedPreferences.getInstance();
    final transactions = prefs.getStringList(transactionsPrefsKey) ?? [];
    if (transactions.isNotEmpty) {
      return transactions.map((t) => Transaction.fromMap(jsonDecode(t))).toList();
    }
    return [];
  }
    Future<List<Transaction>> getTransactions() async {
    return await _loadTransactions();
  }
}
