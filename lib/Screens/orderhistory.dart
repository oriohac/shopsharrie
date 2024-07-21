import 'package:flutter/material.dart';
import 'package:shopsharrie/Screens/orderdetail.dart';
import 'package:shopsharrie/model/dbhelper.dart';

class OrderHistory extends StatefulWidget {
  const OrderHistory({super.key});
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

  void deleteOrder(int id) async {
    await DBHelper.instance.deleteOrder(id);
    fetchOrders();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order deleted successfully'),
        behavior: SnackBarBehavior.floating,
        dismissDirection: DismissDirection.horizontal,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order History'),
      ),
      body: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          var order = orders[index];
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 6, 12, 6),
            child: Dismissible(
              key: Key(order['id'].toString()),
              direction: DismissDirection.endToStart,
              onDismissed: (direction) {
                deleteOrder(order['id']);
              },
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                    side: const BorderSide(color: Color(0xff363939))),
                title: Text(order['product_name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Quantity: ${order['quantity']}'),
                    const Text(
                      "Click for Detail,Swipe to Delete",
                      style: TextStyle(
                        fontFamily: 'poppins',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(255, 200, 28, 1),
                      ),
                    )
                  ],
                ),
                trailing: Text('₦${order['price']}'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetail(order: order),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
