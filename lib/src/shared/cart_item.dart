import 'product.dart';
import 'utils.dart';

class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 1) {
      quantity--;
    }
  }

  String get formattedPrice => formatCurrency(price);
  String get formattedTotalPrice => formatCurrency(totalPrice);
  
  double get price {
    final priceString = product.price.replaceAll('VND', '').trim().replaceAll(',', '');
    return double.tryParse(priceString) ?? 0;
  }
  
  double get totalPrice => price * quantity;
}
