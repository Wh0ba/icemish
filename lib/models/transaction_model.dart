class LogTransaction {
  final String id;
  final String itemName;
  final int itemCount;
  final int totalPrice;
  final DateTime timestamp;

  LogTransaction({
    required this.id,
    required this.itemName,
    required this.itemCount,
    required this.totalPrice,
    required this.timestamp,
  });

  factory LogTransaction.fromMap(Map<String, dynamic> map) {
    return LogTransaction(
      id: map['id'],
      itemName: map['itemName'],
      itemCount: map['itemCount'],
      totalPrice: map['totalPrice'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'itemName': itemName,
      'itemCount': itemCount,
      'totalPrice': totalPrice,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
