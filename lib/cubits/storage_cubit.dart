import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/models/item_model.dart';
import 'package:icemish/models/transaction_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String itemPrefsKey = 'items_prefs_key';
const String transactionsPrefsKey = 'transactions_prefs_key';

const uuid = Uuid();

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
      return LogTransaction(
        id: uuid.v4(),
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

    await uploadLogsWithTransaction(newTransactions);
    clear();
  }

  Future<void> uploadLogsWithTransaction(
      List<LogTransaction> updatedTransactions) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final String pathToLogs = 'users/$uid/logs';
    final logsReference = FirebaseFirestore.instance.collection(pathToLogs);
    final batch = FirebaseFirestore.instance.batch();

    for (final log in updatedTransactions) {
      final logDoc = logsReference.doc(log.id);
      final logSnapshot = await logDoc.get();

      if (!logSnapshot.exists) {
        batch.set(logDoc, log.toMap());
      } else {
        print('Duplicate log found: ${log.id}');
      }
    }

    await batch.commit();
  }

  Future<List<LogTransaction>> _loadTransactions() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final String pathToLogs = 'users/$uid/logs';
    final logsReference = FirebaseFirestore.instance.collection(pathToLogs);
    try {
      // Get all documents in the collection
      final querySnapshot = await logsReference.get();

      // Map documents to LogTransaction objects
      final transactions = querySnapshot.docs.map((doc) {
        return LogTransaction.fromMap(doc.data());
      }).toList();

      return transactions;
    } catch (e) {
      print('Error loading transactions: $e');
      return [];
    }
  }

  Future<List<LogTransaction>> getTransactions() async {
    return await _loadTransactions();
  }

  Future<void> deleteLogTransaction(LogTransaction t) async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final String pathToLogs = 'users/$uid/logs';
    final logsReference = FirebaseFirestore.instance.collection(pathToLogs);
    final batch = FirebaseFirestore.instance.batch();
    batch.delete(logsReference.doc(t.id));
    await batch.commit();
  }
}
