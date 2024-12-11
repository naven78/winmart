import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../shared/product.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/partials.dart';
import '../shared/buttons.dart';
import '../shared/cart_provider.dart';
import '../shared/cart_item.dart';

class ProductPage extends StatefulWidget {
  final Product productData;

  ProductPage({required this.productData});

  @override
  ProductPageState createState() => ProductPageState();
}

class ProductPageState extends State<ProductPage> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        centerTitle: true,
        leading: BackButton(
          color: darkText,
        ),
        title: Text(widget.productData.name, style: h4),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 20),
          child: Center(
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    margin: EdgeInsets.only(top: 50, bottom: 50),
                    padding: EdgeInsets.only(top: 50, bottom: 30),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 15,
                          spreadRadius: 5,
                          color: Color.fromRGBO(0, 0, 0, .05),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(widget.productData.name, style: h5),
                        Text(widget.productData.price, style: h3),
                        Container(
                          margin: EdgeInsets.only(top: 5, bottom: 20),
                          child: RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 50.0,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.orange,
                            ),
                            onRatingUpdate: (rating) {
                              setState(() {});
                            },
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, bottom: 25),
                          child: Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(bottom: 15),
                                child: Text('Số lượng', style: h6),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          _quantity += 1;
                                        });
                                      },
                                      child: Icon(Icons.add),
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(left: 20, right: 20),
                                    child: Text(_quantity.toString(), style: h3),
                                  ),
                                  SizedBox(
                                    width: 55,
                                    height: 55,
                                    child: OutlinedButton(
                                      onPressed: () {
                                        setState(() {
                                          if (_quantity == 1) return;
                                          _quantity -= 1;
                                        });
                                      },
                                      child: Icon(Icons.remove),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 180,
                          child: froyoOutlinedBtn('Mua Ngay', () {
                            final cart = Provider.of<CartProvider>(context, listen: false);
                            cart.addItem(widget.productData, _quantity);
                            Navigator.pushNamed(context, '/checkout');
                          }),
                        ),
                        SizedBox(
                          width: 180,
                          child: froyoTextBtn('Thêm vào giỏ', () {
                            final cart = Provider.of<CartProvider>(context, listen: false);
                            try {
                              cart.addItem(widget.productData, _quantity);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Đã thêm ${_quantity}x ${widget.productData.name} vào giỏ hàng'),
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Không thể thêm sản phẩm vào giỏ hàng'),
                                  backgroundColor: Colors.red,
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: 200,
                    height: 160,
                    child: foodItem(
                      context,
                      widget.productData,
                      isProductPage: true,
                      onTapped: () {},
                      imgWidth: 250,
                      onLike: () {},
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
