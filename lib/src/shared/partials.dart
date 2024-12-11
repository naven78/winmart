import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import '../shared/colors.dart';
import '../shared/styles.dart';
import 'cart_provider.dart';
import 'favorites_provider.dart';

Widget foodItem(BuildContext context, Product food,
    {double imgWidth = 100, onLike, onTapped, bool isProductPage = false}) {
  return Container(
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(5),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Stack(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 3,
              child: Material(
                color: white,
                borderRadius: BorderRadius.circular(5),
                child: InkWell(
                  onTap: onTapped,
                  borderRadius: BorderRadius.circular(5),
                  child: Hero(
                    transitionOnUserGestures: true,
                    tag: food.name,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Image.asset(
                        food.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (!isProductPage)
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(food.name, style: foodNameText),
                          const SizedBox(height: 1),
                          Text(food.price, style: priceText),
                        ],
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          onPressed: () {
                            Provider.of<CartProvider>(context, listen: false).addItem(food);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${food.name} added to cart'),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                          child: const Text(
                            'Add to Cart',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
        Positioned(
          top: 8,
          right: 8,
          child: TextButton(
            style: TextButton.styleFrom(
              padding: const EdgeInsets.all(8),
              shape: const CircleBorder(),
              backgroundColor: Colors.white.withOpacity(0.9),
            ),
            onPressed: onLike,
            child: Consumer<FavoritesProvider>(
              builder: (context, favorites, _) => Icon(
                favorites.items.any((item) => item.name == food.name)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: favorites.items.any((item) => item.name == food.name)
                    ? Colors.red
                    : darkText,
                size: 24,
              ),
            ),
          ),
        ),
        if (food.discount != 0)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '-${food.discount.toString()}%',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    ),
  );
}
