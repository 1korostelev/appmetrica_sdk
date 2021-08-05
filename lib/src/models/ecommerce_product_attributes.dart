part of appmetrica_sdk;

class ProductAttributes {
  final double price;
  final String productCode;
  final String product;
  final String category;
  final int quantity;

  ProductAttributes({
    required this.price,
    required this.product,
    required this.productCode,
    required this.category,
    this.quantity = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'attributes': {
        'price': price,
        'productCode': productCode,
        'product': product,
        'category': category,
        'quantity': quantity,
      },
    };
  }
}
