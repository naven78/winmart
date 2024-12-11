import 'package:flutter/material.dart';
import '../shared/styles.dart';
import '../shared/colors.dart';

class OrderHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: bgColor,
        title: Text('Lịch Sử Đơn Hàng', style: h4),
        leading: BackButton(color: darkText),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Sample data
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Đơn hàng #${1000 + index}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: index == 0 ? Colors.blue[100] : Colors.green[100],
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          index == 0 ? 'Đang giao' : 'Đã giao',
                          style: TextStyle(
                            color: index == 0 ? Colors.blue[900] : Colors.green[900],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Ngày đặt: ${DateTime.now().subtract(Duration(days: index)).toString().substring(0, 10)}',
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tổng tiền: ${(150000 + index * 50000).toString()}₫',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      // Show order details
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Chi tiết đơn hàng #${1000 + index}'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Địa chỉ giao hàng:'),
                              Text('123 Đường ABC, Quận XYZ, TP.HCM'),
                              const SizedBox(height: 8),
                              Text('Phương thức thanh toán:'),
                              Text('COD (Thanh toán khi nhận hàng)'),
                              const SizedBox(height: 8),
                              Text('Sản phẩm:'),
                              Text('- Sản phẩm A x2'),
                              Text('- Sản phẩm B x1'),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Đóng'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 40),
                    ),
                    child: const Text('Xem chi tiết'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
