import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class Item {
  final String name;
  final int price;
  int count;
  Item({required this.name, required this.price, this.count = 0});

  @override
  String toString() => 'Item(name: $name, price: $price, count: $count)';

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'price': price,
      'count': count,
    };
  }

  factory Item.fromMap(Map<String, dynamic> map) {
    return Item(
      name: map['name'] as String,
      price: map['price'] as int,
      count: map['count'] as int? ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Item.fromJson(String source) => Item.fromMap(json.decode(source) as Map<String, dynamic>);
}
