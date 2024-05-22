import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/cubits/storage_cubit.dart';

import '../models/item_model.dart';

class ItemCubit extends Cubit<int> {
  // final CartCubit cartCubit;
  final StorageCubit storageCubit;
  final Item item;

  ItemCubit(this.storageCubit, this.item) : super(0);

  void increment() {
    emit(state + 1);
    item.count += 1;
    storageCubit.updateItem(item);
    // cartCubit.updateTotal(item.price);
  }

  void decrement() {
    if (state > 0) {
      emit(state - 1);
      item.count -= 1;
      storageCubit.updateItem(item);
      // cartCubit.updateTotal(-item.price);
    }
  }
}
