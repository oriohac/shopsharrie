import 'package:flutter/material.dart';
import 'package:shopsharrie/model/productsdata.dart';
class Cart extends StatelessWidget {
  final List<Productsdata> cartItems;

  Cart({required this.cartItems});

  @override
  Widget build(BuildContext context) {
    double totalAmount = cartItems.fold(0, (sum, item) => sum + item.currentprice);

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        backgroundColor: const Color.fromARGB(255, 213, 214, 215),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  var item = cartItems[index];
                  return ListTile(
                    leading: Image.network('https://api.timbu.cloud/images/${item.photos[0].url}'),
                    title: Text(item.name),
                    subtitle: Text('₦${item.currentprice}'),
                    trailing: IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: () {
                        // Remove item from cart logic here
                      },
                    ),
                  );
                },
              ),
            ),
            Divider(),
            ListTile(
              title: Text('Total Amount'),
              trailing: Text('₦$totalAmount', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Checkout logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              ),
              child: Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}
