import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'dart:convert';

import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/fryo_icons.dart';
import '../shared/product.dart';
import '../shared/partials.dart';
import '../shared/language.dart';
import '../shared/cart_provider.dart';
import '../shared/favorites_provider.dart';
import './product_page.dart';
import './search_page.dart';
import '../shared/user_provider.dart';
import './order_history_page.dart';
import './address_management_page.dart';
import './payment_methods_page.dart';
import './personal_info_page.dart';
import './fried_foods_page.dart'; // Added import
import './fast_food_page.dart'; // Added import
import './creamery_page.dart'; // Added import
import './hot_drinks_page.dart'; // Added import
import './vegetables_page.dart'; // Added import

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late TabController _tabController;
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(() {
      if (!_tabController.indexIsChanging) {
        setState(() {
          _selectedIndex = _tabController.index;
        });
      }
    });
    _productsFuture = fetchProducts();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('http://10.0.2.2:3000/api/products'));
      if (response.statusCode == 200) {
        List<dynamic> productData = json.decode(response.body);
        return productData.map((data) => Product.fromJson(data)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Widget storeTab(BuildContext context) {
    return FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No products available'));
        } else {
          final products = snapshot.data!;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: headerTopCategories(),
              ),
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(AppText.vi['all_products'] ?? 'All Products', style: h4),
                            TextButton(
                              onPressed: () {},
                              child: Text('${AppText.vi['view_all'] ?? 'View All'} >', style: contrastText),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return foodItem(
                        context,
                        products[index],
                        onTapped: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProductPage(productData: products[index]),
                            ),
                          );
                        },
                        onLike: () {
                          Provider.of<FavoritesProvider>(context, listen: false)
                              .toggleFavorite(products[index]);
                        },
                      );
                    },
                    childCount: products.length,
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget headerTopCategories() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(left: 15, top: 10),
              child: Text(AppText.vi['all_categories'] ?? 'All Categories', style: h4),
            ),
            Container(
              margin: const EdgeInsets.only(left: 15, top: 2),
              child: TextButton(
                onPressed: () {},
                child: Text('${AppText.vi['view_all'] ?? 'View All'} >', style: contrastText),
              ),
            )
          ],
        ),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: <Widget>[
              categoryItem(AppText.vi['fried_foods'] ?? 'Fried Foods', Fryo.dinner, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FriedFoodsPage(),
                  ),
                );
              }),
              categoryItem(AppText.vi['fast_food'] ?? 'Fast Food', Fryo.food, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FastFoodPage(),
                  ),
                );
              }),
              categoryItem(AppText.vi['creamery'] ?? 'Creamery', Fryo.poop, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CreameryPage(),
                  ),
                );
              }),
              categoryItem(AppText.vi['hot_drinks'] ?? 'Hot Drinks', Fryo.coffee_cup, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HotDrinksPage(),
                  ),
                );
              }),
              categoryItem(AppText.vi['vegetables'] ?? 'Vegetables', Fryo.leaf, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => VegetablesPage(),
                  ),
                );
              }),
            ],
          ),
        )
      ],
    );
  }

  Widget categoryItem(String name, IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(left: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            width: 86,
            height: 86,
            child: FloatingActionButton(
              shape: const CircleBorder(),
              heroTag: name,
              onPressed: onPressed,
              backgroundColor: white,
              child: Icon(icon, size: 35, color: Colors.black87),
            )
          ),
          Text('$name >', style: categoryText)
        ],
      ),
    );
  }

  Widget deals(String dealTitle, {onViewMore, List<Widget>? items}) {
    return Container(
      margin: const EdgeInsets.only(top: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 15, top: 10),
                child: Text(dealTitle, style: h4),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 2),
                child: TextButton(
                  onPressed: onViewMore,
                  child: Text('${AppText.vi['view_all'] ?? 'View All'} >', style: contrastText),
                ),
              )
            ],
          ),
          SizedBox(
            height: 250,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: items ?? [
                Container(
                  margin: const EdgeInsets.only(left: 15),
                  child: Text(
                    'No items available at this moment.',
                    style: taglineText,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cartTab() {
    return Consumer<CartProvider>(builder: (context, cart, child) {
      if (cart.items.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(Fryo.cart, size: 50, color: Colors.grey[400]),
              ),
              const SizedBox(height: 30),
              Text(AppText.vi['cart_empty'] ?? 'Cart Empty', style: h4),
              const SizedBox(height: 15),
              Text(
                AppText.vi['cart_empty_message'] ?? 'Your cart is empty',
                style: taglineText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  _tabController.animateTo(0);
                },
                child: Text(AppText.vi['start_shopping'] ?? 'Start Shopping'),
              ),
            ],
          ),
        );
      }

      return ListView(
        padding: const EdgeInsets.all(15),
        children: [
          ...cart.items.map((item) => Card(
            margin: const EdgeInsets.only(bottom: 15),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    item.product.image,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          item.product.price,
                          style: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          cart.decrementQuantity(item.product.name);
                        },
                      ),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          cart.incrementQuantity(item.product.name);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )).toList(),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${cart.totalAmount.toStringAsFixed(0)}₫',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/checkout');
            },
            child: const Text(
              'Tiến hành thanh toán',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget favoritesTab() {
    return Consumer<FavoritesProvider>(builder: (context, favorites, child) {
      if (favorites.items.isEmpty) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(Fryo.heart_1, size: 50, color: Colors.red[200]),
              ),
              const SizedBox(height: 30),
              Text(AppText.vi['no_favorites'] ?? 'No Favorites', style: h4),
              const SizedBox(height: 15),
              Text(
                AppText.vi['no_favorites_message'] ?? 'Add items to your favorites',
                style: taglineText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  _tabController.animateTo(0);
                },
                child: Text(AppText.vi['browse_products'] ?? 'Browse Products'),
              ),
            ],
          ),
        );
      }

      return GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.9,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
        ),
        itemCount: favorites.items.length,
        itemBuilder: (context, index) {
          return foodItem(
            context,
            favorites.items[index],
            onTapped: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductPage(productData: favorites.items[index]),
                ),
              );
            },
            onLike: () {
              favorites.toggleFavorite(favorites.items[index]);
            },
          );
        },
      );
    });
  }

  Widget profileTab() {
    return Consumer<UserProvider>(builder: (context, userProvider, child) {
      if (!(userProvider.isLoggedIn)) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(Fryo.user_1, size: 50, color: Colors.grey[400]),
              ),
              const SizedBox(height: 30),
              Text(AppText.vi['welcome'] ?? 'Welcome', style: h4),
              const SizedBox(height: 15),
              Text(
                AppText.vi['profile_message'] ?? 'Sign in to manage your account',
                style: taglineText,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () {
                      // For demo purposes, login with sample data
                      userProvider?.login(
                        UserProfile(
                          name: 'Nguyễn Văn A',
                          email: 'nguyenvana@example.com',
                          phone: '0123456789',
                          avatar: 'https://i.pravatar.cc/150?img=1',
                          orders: ['#123', '#124', '#125'],
                        ),
                      );
                    },
                    child: Text(AppText.vi['sign_in'] ?? 'Sign In'),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      side: BorderSide(color: primaryColor),
                    ),
                    onPressed: () {},
                    child: Text(AppText.vi['sign_up'] ?? 'Sign Up'),
                  ),
                ],
              ),
            ],
          ),
        );
      }

      // Logged in view
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(userProvider.user?.avatar ?? ''),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    userProvider.user?.name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    userProvider.user?.email ?? '',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.shopping_bag_outlined),
                    title: const Text('Đơn hàng của tôi'),
                    subtitle: Text('${userProvider.user?.orders.length ?? 0} đơn hàng'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderHistoryPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: const Text('Địa chỉ giao hàng'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddressManagementPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.payment_outlined),
                    title: const Text('Phương thức thanh toán'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentMethodsPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text('Thông tin cá nhân'),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PersonalInfoPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  // Removed Help & Support button
                  // Removed Privacy Policy button
                  // Removed About Us button
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () {
                        userProvider?.logout();
                      },
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget settingsTab() {
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.notifications_outlined, color: primaryColor),
                    title: Text(AppText.vi['notifications'] ?? 'Notifications', style: const TextStyle(fontSize: 16)),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {},
                      activeColor: primaryColor,
                    ),
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.language_outlined, color: primaryColor),
                    title: Text(AppText.vi['language'] ?? 'Language', style: const TextStyle(fontSize: 16)),
                    trailing: const Text('Tiếng Việt'),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.location_on_outlined, color: primaryColor),
                    title: Text(AppText.vi['delivery_address'] ?? 'Delivery Address', style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.payment_outlined, color: primaryColor),
                    title: Text(AppText.vi['payment_methods'] ?? 'Payment Methods', style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.help_outline, color: primaryColor),
                    title: Text(AppText.vi['help_support'] ?? 'Help & Support', style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.privacy_tip_outlined, color: primaryColor),
                    title: Text(AppText.vi['privacy_policy'] ?? 'Privacy Policy', style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(),
                  ListTile(
                    leading: Icon(Icons.info_outline, color: primaryColor),
                    title: Text(AppText.vi['about_us'] ?? 'About Us', style: const TextStyle(fontSize: 16)),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            TextButton(
              onPressed: () {},
              child: Text(
                AppText.vi['sign_out'] ?? 'Sign Out',
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          iconSize: 21,
          icon: const Icon(Fryo.funnel),
        ),
        backgroundColor: primaryColor,
        title: Text('WinMart', style: logoWhiteStyle, textAlign: TextAlign.center),
        actions: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SearchPage(),
                ),
              );
            },
            iconSize: 21,
            icon: const Icon(Fryo.magnifier),
          ),
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () {},
            iconSize: 21,
            icon: const Icon(Fryo.alarm),
          )
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          storeTab(context),
          cartTab(),
          favoritesTab(),
          profileTab(),
          settingsTab(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: const Icon(Fryo.shop, size: 20),
              label: AppText.vi['store'] ?? 'Store',
            ),
            BottomNavigationBarItem(
              icon: Consumer<CartProvider>(
                builder: (context, cart, child) => Stack(
                  children: [
                    const Icon(Fryo.cart, size: 20),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            cart.itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              label: AppText.vi['cart'] ?? 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Consumer<FavoritesProvider>(
                builder: (context, favorites, child) => Stack(
                  children: [
                    const Icon(Fryo.heart_1, size: 20),
                    if (favorites.items.isNotEmpty)
                      Positioned(
                        right: -2,
                        top: -2,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            favorites.items.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              label: AppText.vi['favorites'] ?? 'Favorites',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Fryo.user_1, size: 20),
              label: AppText.vi['profile'] ?? 'Profile',
            ),
            BottomNavigationBarItem(
              icon: const Icon(Fryo.cog_1, size: 20),
              label: AppText.vi['settings'] ?? 'Settings',
            ),
          ],
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey[400],
          showUnselectedLabels: true,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
              _tabController.animateTo(index);
            });
          },
        ),
      ),
    );
  }
}