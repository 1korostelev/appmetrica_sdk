part of appmetrica_sdk;

class CartAttributes {
  String cartId;
  List<ProductAttributes> cartItems;

  CartAttributes({required this.cartId, required this.cartItems});

  Map<String, dynamic> toMap() {
    return {
      'cartId': cartId,
      'cartItems': buildCartItems(),
    };
  }

  List<Map> buildCartItems() {
    List<Map> result = [];
    cartItems.forEach((element) => result.add(element.toMap()));
    return result;
  }
}

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
