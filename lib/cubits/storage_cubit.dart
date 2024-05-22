import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icemish/models/item_model.dart';

class StorageCubit extends Cubit<List<Item>> {
  StorageCubit() : super([]) {
    addItem(Item(name: 'Chocolate', price: 500, count: 0));
    //TODO: load items from storage
  }

  void addItem(Item item) {
    if (state.any((i) => i.name == item.name)) {
      return;
    }
    emit([...state, item]);
  }

  void updateItem(Item item) {
    emit([...state.where((i) => i.name != item.name), item]);
  }

  void removeItem(Item item) {
    emit(state.where((i) => i.name != item.name).toList());
  }
}
