import 'package:flutter/material.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';

class PaymentMethod {
  final String id;
  final String type;
  final String lastFourDigits;
  final String bankName;
  bool isDefault;

  PaymentMethod({
    required this.id,
    required this.type,
    required this.lastFourDigits,
    required this.bankName,
    this.isDefault = false,
  });
}

class PaymentMethodsPage extends StatefulWidget {
  @override
  _PaymentMethodsPageState createState() => _PaymentMethodsPageState();
}

class _PaymentMethodsPageState extends State<PaymentMethodsPage> {
  List<PaymentMethod> paymentMethods = [
    PaymentMethod(
      id: '1',
      type: 'Visa',
      lastFourDigits: '4567',
      bankName: 'VietcomBank',
      isDefault: true,
    ),
    PaymentMethod(
      id: '2',
      type: 'MasterCard',
      lastFourDigits: '8901',
      bankName: 'BIDV',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text('Phương Thức Thanh Toán', style: h4),
        leading: BackButton(color: darkText),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // COD Section
              Card(
                child: ListTile(
                  leading: const Icon(Icons.money),
                  title: const Text(
                    'Thanh toán khi nhận hàng (COD)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: const Text('Thanh toán bằng tiền mặt'),
                ),
              ),
              const SizedBox(height: 16),
              
              // Bank Cards Section
              const Text(
                'Thẻ ngân hàng',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...paymentMethods.map((method) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(
                    method.type == 'Visa' ? Icons.credit_card : Icons.credit_card_outlined,
                    color: primaryColor,
                  ),
                  title: Text(
                    '${method.type} ****${method.lastFourDigits}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(method.bankName),
                  trailing: PopupMenuButton(
                    itemBuilder: (context) => [
                      if (!method.isDefault)
                        PopupMenuItem(
                          child: ListTile(
                            leading: const Icon(Icons.check_circle_outline),
                            title: const Text('Đặt làm mặc định'),
                            contentPadding: EdgeInsets.zero,
                          ),
                          onTap: () {
                            setState(() {
                              for (var m in paymentMethods) {
                                m.isDefault = m.id == method.id;
                              }
                            });
                          },
                        ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(Icons.delete, color: Colors.red),
                          title: const Text('Xóa', style: TextStyle(color: Colors.red)),
                          contentPadding: EdgeInsets.zero,
                        ),
                        onTap: () {
                          setState(() {
                            paymentMethods.removeWhere((m) => m.id == method.id);
                          });
                        },
                      ),
                    ],
                  ),
                ),
              )).toList(),
            ],
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
              onPressed: () {
                _showAddCardDialog(context);
              },
              child: const Text(
                'Thêm Thẻ Mới',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCardDialog(BuildContext context) {
    final _cardNumberController = TextEditingController();
    final _expiryController = TextEditingController();
    final _cvvController = TextEditingController();
    final _bankNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm Thẻ Mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Số thẻ',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _expiryController,
                decoration: const InputDecoration(
                  labelText: 'Ngày hết hạn',
                  hintText: 'MM/YY',
                ),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _cvvController,
                decoration: const InputDecoration(
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                keyboardType: TextInputType.number,
                obscureText: true,
              ),
              TextField(
                controller: _bankNameController,
                decoration: const InputDecoration(
                  labelText: 'Tên ngân hàng',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_cardNumberController.text.isNotEmpty &&
                  _expiryController.text.isNotEmpty &&
                  _cvvController.text.isNotEmpty &&
                  _bankNameController.text.isNotEmpty) {
                setState(() {
                  paymentMethods.add(PaymentMethod(
                    id: DateTime.now().toString(),
                    type: 'Visa',
                    lastFourDigits: _cardNumberController.text.substring(
                      _cardNumberController.text.length - 4,
                    ),
                    bankName: _bankNameController.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Thêm'),
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: white,
            ),
          ),
        ],
      ),
    );
  }
}
