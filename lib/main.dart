import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'src/screens/signin_page.dart';
import 'src/screens/singup_page.dart';
import 'src/screens/welcome_page.dart';
import 'src/screens/dashboard.dart';
import 'src/screens/product_page.dart';
import 'src/screens/checkout_page.dart';
import 'src/shared/product.dart';
import 'src/shared/cart_provider.dart';
import 'src/shared/favorites_provider.dart';
import 'src/shared/checkout_provider.dart';
import 'src/shared/user_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
        title: 'WinMart',
        theme: ThemeData(
          primarySwatch: Colors.green,
        ),
        home: WelcomePage(pageTitle: 'Welcome'),
        routes: {
          '/signup': (_) => SignUpPage(),
          '/signin': (_) => SignInPage(),
          '/dashboard': (_) => Dashboard(),
          '/productPage': (_) => ProductPage(productData: Product()),
          '/checkout': (_) => CheckoutPage(),
        },
        debugShowCheckedModeBanner: false, // This line removes the debug banner
      ),
    );
  }
}