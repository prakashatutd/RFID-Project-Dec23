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

// Additional product info that is shown in pop-up (currently not implemented)
class ProductDetailedInfo {
  final String imageUrl;
  final String description;
  final int width;
  final int height;
  final int depth;
  final int weight;

  ProductDetailedInfo(
    this.imageUrl,
    this.description,
    this.width,
    this.height,
    this.depth,
    this.weight) {
  }
}