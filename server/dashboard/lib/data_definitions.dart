class Product {
  final int id;
  final String name;
  final String category;
  final int reorderPoint;
  int quantity;

  Product(
    this.id,
    this.name,
    this.category,
    this.reorderPoint,
    this.quantity
  );

  Product.fromJson(Map<String, dynamic> json)
    : id           = json['id']       as int,
      name         = json['name']     as String,
      category     = json['category'] as String,
      reorderPoint = json['rop']      as int,
      quantity     = json['quantity'] as int;
}

enum ScanAction {
  Receive,
  Dispatch,
}

class ScanEvent {
  final String gateId;
  final int productId;
  final String productName;
  final ScanAction action;
  final int quantity;
  final DateTime scanTime;

  ScanEvent(
    this.gateId,
    this.productId,
    this.productName,
    this.action,
    this.quantity,
    this.scanTime,
  );

  ScanEvent.fromJson(Map<String, String> json)
    : gateId      = json['gate_id']      as String,
      productId   = json['product_id']   as int,
      productName = json['product_name'] as String,
      action      = json['action']       as ScanAction,
      quantity    = json['quantity']     as int,
      scanTime    = DateTime.parse(json['time'] as String);
}