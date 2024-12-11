import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/product.dart';
import '../shared/partials.dart';
import '../shared/language.dart';
import '../config/api_config.dart';
import './product_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Product> _searchResults = [];
  
  List<Product> _allProducts = [];

  @override
  void initState() {
    super.initState();
    _fetchAllProducts();
  }

  Future<void> _fetchAllProducts() async {
    try {
      final response = await http.get(Uri.parse(ApiConfig.productsUrl));
      if (response.statusCode == 200) {
        List<dynamic> productData = json.decode(response.body);
        setState(() {
          _allProducts = productData.map((data) => Product.fromJson(data)).toList();
        });
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error fetching products: $e');
    }
  }

  void _performSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _allProducts
            .where((product) =>
                product.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: TextField(
          controller: _searchController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: AppText.vi['search_products'],
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _performSearch,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _searchResults.isEmpty && _searchController.text.isEmpty
          ? Center(
              child: Text(AppText.vi['search_message']!,
                  style: TextStyle(color: Colors.grey[600])))
          : _searchResults.isEmpty
              ? Center(
                  child: Text(AppText.vi['no_results']!,
                      style: TextStyle(color: Colors.grey[600])))
              : ListView.builder(
                  itemCount: _searchResults.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(
                        _searchResults[index].image,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text(_searchResults[index].name),
                      subtitle: Text(_searchResults[index].price),
                      trailing: _searchResults[index].discount > 0
                          ? Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '-${_searchResults[index].discount}%',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )
                          : null,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductPage(
                              productData: _searchResults[index],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
