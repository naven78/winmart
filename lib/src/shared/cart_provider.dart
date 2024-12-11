import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'product.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0, (sum, item) => sum + item.totalPrice);
  }

  void addItem(Product product, [int quantity = 1]) {
    final existingCartItemIndex = _items.indexWhere(
      (item) => item.product.name == product.name,
    );

    if (existingCartItemIndex >= 0) {
      for (int i = 0; i < quantity; i++) {
        _items[existingCartItemIndex].incrementQuantity();
      }
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(String productName) {
    _items.removeWhere((item) => item.product.name == productName);
    notifyListeners();
  }

  void incrementQuantity(String productName) {
    final item = _items.firstWhere((item) => item.product.name == productName);
    item.incrementQuantity();
    notifyListeners();
  }

  void decrementQuantity(String productName) {
    final item = _items.firstWhere((item) => item.product.name == productName);
    if (item.quantity > 1) {
      item.decrementQuantity();
    } else {
      removeItem(productName);
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
