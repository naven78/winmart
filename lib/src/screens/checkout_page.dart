import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/checkout_provider.dart';
import '../shared/cart_provider.dart';
import '../shared/colors.dart';
import '../shared/styles.dart';
import '../shared/utils.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thanh Toán', style: h4),
        backgroundColor: bgColor,
        elevation: 0,
      ),
      body: Consumer2<CheckoutProvider, CartProvider>(
        builder: (context, checkout, cart, child) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Addresses Section
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Địa Chỉ Giao Hàng', style: h5),
                        SizedBox(height: 16),
                        if (checkout.addresses.isEmpty)
                          Text('Chưa có địa chỉ nào được thêm')
                        else
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: checkout.addresses.length,
                            itemBuilder: (context, index) {
                              final address = checkout.addresses[index];
                              return RadioListTile<Address>(
                                value: address,
                                groupValue: checkout.selectedAddress,
                                title: Text('${address.street}, ${address.district}, ${address.city}'),
                                subtitle: Text(address.phoneNumber),
                                onChanged: (Address? value) {
                                  if (value != null) {
                                    checkout.selectAddress(value);
                                  }
                                },
                              );
                            },
                          ),
                        ElevatedButton(
                          onPressed: () {
                            _showAddAddressDialog(context);
                          },
                          child: Text('Thêm Địa Chỉ Mới'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Payment Method Section
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Phương Thức Thanh Toán', style: h5),
                        RadioListTile<PaymentMethod>(
                          value: PaymentMethod.cod,
                          groupValue: checkout.paymentMethod,
                          title: Text('Thanh toán khi nhận hàng (COD)'),
                          onChanged: (PaymentMethod? value) {
                            if (value != null) {
                              checkout.setPaymentMethod(value);
                            }
                          },
                        ),
                        RadioListTile<PaymentMethod>(
                          value: PaymentMethod.bankTransfer,
                          groupValue: checkout.paymentMethod,
                          title: Text('Chuyển khoản ngân hàng'),
                          onChanged: (PaymentMethod? value) {
                            if (value != null) {
                              checkout.setPaymentMethod(value);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // Order Summary
                Card(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tổng Đơn Hàng', style: h5),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng tiền hàng:'),
                            Text(formatCurrency(cart.totalAmount)),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phí vận chuyển:'),
                            Text(formatCurrency(15000)),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tổng thanh toán:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(formatCurrency(cart.totalAmount + 15000), 
                                 style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: checkout.selectedAddress == null
                        ? null
                        : () => _processCheckout(context),
                    child: Text('Xác Nhận Đặt Hàng'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      foregroundColor: white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Thêm Địa Chỉ Mới'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _streetController,
                  decoration: InputDecoration(labelText: 'Địa chỉ'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _districtController,
                  decoration: InputDecoration(labelText: 'Quận/Huyện'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập quận/huyện';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(labelText: 'Thành phố'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập thành phố';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Số điện thoại'),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập số điện thoại';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final address = Address(
                  street: _streetController.text,
                  city: _cityController.text,
                  district: _districtController.text,
                  phoneNumber: _phoneController.text,
                );
                Provider.of<CheckoutProvider>(context, listen: false)
                    .addAddress(address);
                Navigator.pop(context);
                _clearForm();
              }
            },
            child: Text('Thêm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: white,
            ),
          ),
        ],
      ),
    );
  }

  void _processCheckout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Đặt Hàng Thành Công'),
        content: Text('Cảm ơn bạn đã đặt hàng. Chúng tôi sẽ sớm liên hệ với bạn.'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Provider.of<CartProvider>(context, listen: false).clear();
            },
            child: Text('OK'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: white,
            ),
          ),
        ],
      ),
    );
  }

  void _clearForm() {
    _streetController.clear();
    _cityController.clear();
    _districtController.clear();
    _phoneController.clear();
  }

  @override
  void dispose() {
    _streetController.dispose();
    _cityController.dispose();
    _districtController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
