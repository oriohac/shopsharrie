import 'package:flutter/material.dart';
import 'package:shopsharrie/model/dbhelper.dart';

class OrderHistory extends StatefulWidget {
 const  OrderHistory({super.key});
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    var fetchedOrders = await DBHelper.instance.getAllOrders();
    setState(() {
      orders = fetchedOrders;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return ListTile(
            title: Text(order['product_name']),
            subtitle: Text('Quantity: ${order['quantity']}'),
            trailing: Text('₦${order['price']}'),
            onTap: () {
              // Navigate to order detail page
              // Implement navigation to detail page of this order
            },
          );
        },
      ),
    );
  }
}
