class Transaction {
  final int id;
  final int totalQuantity;
  final double totalPrice;
  final DateTime timestamp;
  final List<TransactionDetail> transDetail;

  Transaction({
    required this.id,
    required this.totalQuantity,
    required this.totalPrice,
    required this.timestamp,
    required this.transDetail,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      totalQuantity: json['totalQuantity'],
      totalPrice: json['totalPrice'],
      timestamp: DateTime.parse(json['timestamp']),
      transDetail: (json['transdetail'] as List)
          .map((detail) => TransactionDetail.fromJson(detail))
          .toList(),
    );
  }
}

class TransactionDetail {
  final int id;
  final String itemName;
  final int itemQuantity;
  final double itemPrice;
  final int size;

  TransactionDetail({
    required this.id,
    required this.itemName,
    required this.itemQuantity,
    required this.itemPrice,
    required this.size,
  });

  factory TransactionDetail.fromJson(Map<String, dynamic> json) {
    return TransactionDetail(
      id: json['id'],
      itemName: json['itemName'],
      itemQuantity: json['itemQuantity'],
      itemPrice: json['itemPrice'],
      size: json['size'],
    );
  }
}

const Map<int, String> sizeDisplayNames = {
  10: 'S',
  20: 'M',
  30: 'L',
  40: 'XL',
  50: 'XXL',
  60: 'XXXL',
};

extension TransactionDetailExtension on TransactionDetail {
  String get sizeDisplayName {
    return sizeDisplayNames[size] ?? '?';
  }
}
