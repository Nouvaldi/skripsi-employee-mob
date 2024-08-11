class Item {
  final int id;
  final String itemName;
  final int status;
  final int totalItem;
  final double price;

  Item({
    required this.id,
    required this.itemName,
    required this.status,
    required this.totalItem,
    required this.price,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      itemName: json['itemName'],
      status: json['status'],
      totalItem: json['totalItem'],
      price: json['price'],
    );
  }
}
