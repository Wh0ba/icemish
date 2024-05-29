class Transaction {
  final String itemName;
  final int itemCount;
  final int totalPrice;
  final DateTime timestamp;

  Transaction({
    required this.itemName,
    required this.itemCount,
    required this.totalPrice,
    required this.timestamp,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      itemName: map['itemName'],
      itemCount: map['itemCount'],
      totalPrice: map['totalPrice'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'itemName': itemName,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
