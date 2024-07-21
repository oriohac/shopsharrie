import 'package:flutter/material.dart';

class OrderDetail extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetail({Key? key, required this.order}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Product: ',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Text("${order['product_name']}")
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Quantity: ',
                  style: const TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text("${order['quantity']}")
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Price: ',
                  style: const TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text("₦${order['price']}")
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text(
                  'Order Date: ',
                  style: const TextStyle(fontSize: 16),
                ),
                Spacer(),
                Text("${order['order_date']}")
              ],
            ),
          ],
        ),
      ),
    );
  }
}
