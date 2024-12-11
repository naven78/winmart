import 'package:flutter/foundation.dart';

class Address {
  final String street;
  final String city;
  final String district;
  final String phoneNumber;

  Address({
    required this.street,
    required this.city,
    required this.district,
    required this.phoneNumber,
  });
}

enum PaymentMethod { cod, bankTransfer }

class CheckoutProvider with ChangeNotifier {
  Address? _selectedAddress;
  PaymentMethod _paymentMethod = PaymentMethod.cod;
  List<Address> _addresses = [];

  Address? get selectedAddress => _selectedAddress;
  PaymentMethod get paymentMethod => _paymentMethod;
  List<Address> get addresses => _addresses;

  void addAddress(Address address) {
    _addresses.add(address);
    if (_addresses.length == 1) {
      _selectedAddress = address;
    }
    notifyListeners();
  }

  void selectAddress(Address address) {
    _selectedAddress = address;
    notifyListeners();
  }

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethod = method;
    notifyListeners();
  }
}
