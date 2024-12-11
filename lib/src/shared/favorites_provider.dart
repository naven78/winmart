import 'package:flutter/foundation.dart';
import 'product.dart';

class FavoritesProvider with ChangeNotifier {
  final List<Product> _favorites = [];

  List<Product> get items => _favorites;

  int get itemCount => _favorites.length;

  bool isFavorite(String productName) {
    return _favorites.any((item) => item.name == productName);
  }

  void toggleFavorite(Product product) {
    final isExist = _favorites.any((item) => item.name == product.name);
    if (isExist) {
      _favorites.removeWhere((item) => item.name == product.name);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
  }

  void removeItem(String productName) {
    _favorites.removeWhere((item) => item.name == productName);
    notifyListeners();
  }
}
