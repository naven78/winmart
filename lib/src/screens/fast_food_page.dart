import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../shared/product.dart';
import '../shared/styles.dart';
import '../shared/cart_provider.dart';
import '../config/api_config.dart';
import 'package:provider/provider.dart';

class FastFoodPage extends StatelessWidget {
  const FastFoodPage({Key? key}) : super(key: key);

  Future<List<Product>> fetchFastFoods() async {
    try {
      final response = await http.get(Uri.parse('${ApiConfig.productsUrl}?category=fast_food'));
      if (response.statusCode == 200) {
        List<dynamic> productData = json.decode(response.body);
        return productData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load fast foods');
      }
    } catch (e) {
      throw Exception('Failed to load fast foods: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fast Food', style: logoWhiteStyle),
      ),
      body: FutureBuilder<List<Product>>(
        future: fetchFastFoods(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No fast foods available'));
          } else {
            final products = snapshot.data!;
            return ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Image.asset(
                          products[index].image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(products[index].name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(products[index].price, style: const TextStyle(color: Colors.grey)),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_shopping_cart),
                          onPressed: () {
                            // Add to cart functionality
                            Provider.of<CartProvider>(context, listen: false).addItem(products[index]);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
