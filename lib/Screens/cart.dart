import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopsharrie/Screens/animatedloading.dart';
import 'package:shopsharrie/model/productsdata.dart';
import 'package:http/http.dart' as http;

class Cart extends StatefulWidget {
  final List<Productsdata> cartItems;

  const Cart({
    super.key,
    required this.cartItems,
  });

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  Future<ProductsResponse> getProducts() async {
    final apiKey = dotenv.env['Apikey'];
    final appId = dotenv.env['Appid'];
    final orgId = dotenv.env['organization_id'];
    const url = 'https://api.timbu.cloud/products';
    final response = await http.get(
        Uri.parse("$url?organization_id=$orgId&Apikey=$apiKey&Appid=$appId"));
    if (response.statusCode == 200) {
      return ProductsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Error: Could not retrieve data");
    }
  }

  late List<Map<String, dynamic>> _cartItems;
  late Future<ProductsResponse> products;
  // late List<Productsdata> cartItems;
  @override
  void initState() {
    super.initState();
    // cartItems = widget.cartItems;
    products = getProducts();
    _cartItems = widget.cartItems
        .map((item) => {'product': item, 'quantity': item.availableQuantity})
        .toList();
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      _cartItems.removeAt(index);
    });
  }

//function to complete order and clear the cart
  void completeOrder() {
    setState(() {
      _cartItems.clear();
    });
//Success message after completing order
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text('Success'),
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      dismissDirection: DismissDirection.horizontal,
    ));
    Navigator.pushNamed(context, "/ordersuccess");
  }

  @override
  Widget build(BuildContext context) {
    double deliveryFee = 2;
    double totalAmount =
        widget.cartItems.fold(0, (sum, item) => sum + item.currentprice);

    return Scaffold(
      appBar: AppBar(
        actions: const [
          Divider(
            color: Color(0xffcccbcb),
          ),
          Text(
            "Cart",
            style: TextStyle(
                fontFamily: 'poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff0a0b0a)),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 48.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 20,
            ),
          ),
        ],
        backgroundColor: const Color(0xffffffff),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _cartItems.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.network(
                    'https://api.timbu.cloud/images/${_cartItems[index]['product'].photos[0].url}',
                    width: 87,
                    height: 98.26,
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _cartItems[index]['product'].uniqueid,
                        style: const TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w300,
                          fontSize: 12,
                          color: Color(0xff6E6E6E),
                        ),
                      ),
                      Text(
                        _cartItems[index]['product'].name,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff0a0b0a),
                        ),
                      ),
                    ],
                  ),
                  subtitle: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(0),
                        height: 24,
                        width: 66,
                        decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xff818181),
                            ),
                            borderRadius: BorderRadius.circular(1.83)),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: const Icon(
                                Icons.remove,
                                size: 7,
                              ),
                              onPressed: () => _decrementQuantity(index),
                            ),
                            Flexible(
                              child: Text(
                                '${_cartItems[index]['quantity'].toInt()}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'inter',
                                    fontWeight: FontWeight.w600),
                                    textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints(),
                              icon: const Icon(
                                Icons.add,
                                size: 7,
                              ),
                              onPressed: () => _incrementQuantity(index),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 22.96,
                        width: 30.73,
                        decoration:
                            const BoxDecoration(color: Color(0xffCC474E)),
                        child: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 10,
                            color: Color(0xffFFFFFF),
                          ),
                          onPressed: () {
                            removeItem(index);
                          },
                        ),
                      ),
                    ],
                  ),
                  trailing: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Unit price",
                        style: TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: Color(0xff5A5A5A),
                        ),
                      ),
                      Text(
                        'N${_cartItems[index]['product'].currentprice * _cartItems[index]['quantity']}',
                        style: const TextStyle(
                          fontFamily: 'poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                          color: Color(0xff0a0b0a),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Center(
            child: Card(
              color: const Color(0xffFEFEFE),
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xff408c2b))),
              child: Column(
                children: [
                  const Text('Cart summary'),
                  Row(
                    children: [const Text("Sub-total"), Text("$totalAmount")],
                  ),
                  Row(
                    children: [const Text("Delivery"), Text("$deliveryFee")],
                  ),
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                            side: const BorderSide(
                              color: Color(0xff363939),
                            )),
                        child: const Text(
                          "Cancel",
                          style: TextStyle(
                            color: Color(0xff363939),
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total Amout',
                            style: TextStyle(
                              color: Color(0xff797A7B),
                              fontWeight: FontWeight.w400,
                              fontFamily: 'poppins',
                            ),
                          ),
                          Text(
                            'N${totalAmount + deliveryFee}',
                            style: const TextStyle(
                                color: Color(0xff363939),
                                fontFamily: 'inter',
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                            backgroundColor: const Color(0xff408C2B),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(3.83))),
                        child: const Text(
                          "Checkout",
                          style: TextStyle(color: Color(0xffFAFAFA)),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          Row(
            children: [
              const Text(
                "Recently viewed",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xff0A0B0A),
                  fontWeight: FontWeight.w300,
                  fontFamily: 'poppins',
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: const Text(
                  "View all",
                  style: TextStyle(
                    color: Color(0xff408C2B),
                    fontSize: 12,
                    fontFamily: 'poppins',
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(
            height: 48,
          ),
          Expanded(
            child: FutureBuilder<ProductsResponse>(
              future: products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: Animatedloading(),
                  );
                } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return const Center(child: Text('No products found'));
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  final random = Random();
                  final List<Productsdata> items =
                      List.from(snapshot.data!.items);
                  items.shuffle(random);
                  const int subsetLength = 1;
                  final List<Productsdata> randomSubset =
                      items.take(subsetLength).toList();
                  return SizedBox(
                    height: 500,
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                      ),
                      itemCount: randomSubset.length,
                      itemBuilder: (context, index) {
                        var prefix = randomSubset[index];

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(2)),
                            elevation: 0,
                            color: Colors.white,
                            child: Column(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: prefix.photos.isNotEmpty
                                        ? Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: Image.network(
                                              'https://api.timbu.cloud/images/${prefix.photos[0].url}',
                                              fit: BoxFit.cover,
                                            ),
                                          )
                                        : Container(),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  prefix.name,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontFamily: 'poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      fontSize: 10,
                                                      color: Color(0xff797A7B)),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '₦${prefix.currentprice.toString()}',
                                                  style: const TextStyle(
                                                      fontFamily: 'poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14,
                                                      color: Color(0xff363939)),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 24,
                                            width: 56,
                                            child: ElevatedButton(
                                              onPressed: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    title: const Text(
                                                        "Item Added"),
                                                    content: const Text(
                                                        "Check it in your cart"),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                    ),
                                                  ),
                                                );
                                              },
                                              style: ElevatedButton.styleFrom(
                                                padding:
                                                    const EdgeInsets.all(0),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(
                                                      color: Colors.green),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                              ),
                                              child: const Text(
                                                'Add to Cart',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 7.1,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
