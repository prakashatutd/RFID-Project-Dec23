enum ScanAction {
  Receive,
  Dispatch,
}

class ScanEvent {
  final String gateId;
  final int productId;
  final String productName;
  final int action;
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

  ScanEvent.fromJson(Map<String, dynamic> json)
    : gateId      = json['gate_id']      as String,
      productId   = json['product_id']   as int,
      productName = json['product_name'] as String,
      action      = json['action']       as int,
      quantity    = json['quantity']     as int,
      scanTime    = DateTime.parse(json['time'] as String);
}