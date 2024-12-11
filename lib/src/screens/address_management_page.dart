import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';
import '../shared/checkout_provider.dart';

class AddressManagementPage extends StatefulWidget {
  @override
  _AddressManagementPageState createState() => _AddressManagementPageState();
}

class _AddressManagementPageState extends State<AddressManagementPage> {
  final _formKey = GlobalKey<FormState>();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _districtController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text('Địa Chỉ Giao Hàng', style: h4),
        leading: BackButton(color: darkText),
      ),
      body: Consumer<CheckoutProvider>(
        builder: (context, checkout, child) {
          return Stack(
            children: [
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: checkout.addresses.length,
                itemBuilder: (context, index) {
                  final address = checkout.addresses[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      title: Text(
                        '${address.street}, ${address.district}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(address.city),
                          Text(address.phoneNumber),
                        ],
                      ),
                      trailing: PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.edit),
                              title: const Text('Chỉnh sửa'),
                              contentPadding: EdgeInsets.zero,
                            ),
                            onTap: () {
                              // Edit address
                              _streetController.text = address.street;
                              _cityController.text = address.city;
                              _districtController.text = address.district;
                              _phoneController.text = address.phoneNumber;
                              _showAddAddressDialog(context, isEdit: true);
                            },
                          ),
                          PopupMenuItem(
                            child: ListTile(
                              leading: const Icon(Icons.delete, color: Colors.red),
                              title: const Text('Xóa', style: TextStyle(color: Colors.red)),
                              contentPadding: EdgeInsets.zero,
                            ),
                            onTap: () {
                              // Delete address
                              checkout.addresses.removeAt(index);
                              checkout.notifyListeners();
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                bottom: 16,
                left: 16,
                right: 16,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () => _showAddAddressDialog(context),
                  child: const Text(
                    'Thêm Địa Chỉ Mới',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showAddAddressDialog(BuildContext context, {bool isEdit = false}) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEdit ? 'Chỉnh Sửa Địa Chỉ' : 'Thêm Địa Chỉ Mới'),
        content: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _streetController,
                  decoration: const InputDecoration(labelText: 'Địa chỉ'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập địa chỉ';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _districtController,
                  decoration: const InputDecoration(labelText: 'Quận/Huyện'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập quận/huyện';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'Thành phố'),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'Vui lòng nhập thành phố';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Số điện thoại'),
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
            child: const Text('Hủy'),
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
            child: Text(isEdit ? 'Cập Nhật' : 'Thêm'),
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
