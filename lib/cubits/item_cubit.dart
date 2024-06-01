import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';

import '../models/item_model.dart';

class ItemCubit extends Cubit<int> {
  final StorageCubit storageCubit;
  final Item item;

  StreamSubscription<List<Item>>? _storageSubscription;

  ItemCubit(this.storageCubit, this.item) : super(item.count) {
    _storageSubscription = storageCubit.stream.listen((items) {
      final updatedItem = items.firstWhere((i) => i.name == item.name, orElse: () => item);
      emit(updatedItem.count);
    });
  }

  void increment() {
    emit(state + 1);
    item.count += 1;
    storageCubit.updateItem(item);
  }

  void decrement() {
    if (state > 0) {
      emit(state - 1);
      item.count -= 1;
      storageCubit.updateItem(item);
    }
  }
    @override
  Future<void> close() {
    _storageSubscription?.cancel();
    return super.close();
  }
}
