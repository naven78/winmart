class Product {
  String name, price, image;
  bool userLiked;
  double discount;

  Product({
    this.name = '',
    this.price = '',
    this.discount = 0,
    this.image = '',
    this.userLiked = false,
  });

  // Method to create a Product from JSON
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      price: json['price']?.toString() ?? '',
      image: json['image'] ?? '',
      userLiked: json['userLiked'] ?? false,
      discount: json['discount']?.toDouble() ?? 0.0,
    );
  }
}
