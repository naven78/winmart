import 'package:flutter/foundation.dart';

class UserProfile {
  final String name;
  final String email;
  final String phone;
  final String avatar;
  final List<String> orders;

  UserProfile({
    required this.name,
    required this.email,
    required this.phone,
    required this.avatar,
    required this.orders,
  });
}

class UserProvider with ChangeNotifier {
  UserProfile? _user;
  bool _isLoggedIn = false;

  UserProfile? get user => _user;
  bool get isLoggedIn => _isLoggedIn;

  void login(UserProfile user) {
    _user = user;
    _isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isLoggedIn = false;
    notifyListeners();
  }

  void updateProfile(UserProfile user) {
    _user = user;
    notifyListeners();
  }
}
