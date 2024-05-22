// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {
  final String name;
  final int price;
  int count;
  Item({required this.name, required this.price, this.count = 0});

  @override
  String toString() => 'Item(name: $name, price: $price, count: $count)';
}
