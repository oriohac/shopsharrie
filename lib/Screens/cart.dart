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
  double deliveryFee = 2;
  double totalAmount = 0;
  @override
  void initState() {
    super.initState();
    // cartItems = widget.cartItems;
    products = getProducts();
    _cartItems = widget.cartItems
        .map((item) => {'product': item, 'quantity': item.availableQuantity})
        .toList();
    totalAmount = _calculateTotalAmount();
  }

  double _calculateTotalAmount() {
    return _cartItems.fold(0,
        (sum, item) => sum + (item['product'].currentprice * item['quantity']));
  }

  void _incrementQuantity(int index) {
    setState(() {
      _cartItems[index]['quantity']++;
      totalAmount = _calculateTotalAmount();
    });
  }

  void _decrementQuantity(int index) {
    setState(() {
      if (_cartItems[index]['quantity'] > 1) {
        _cartItems[index]['quantity']--;
        totalAmount = _calculateTotalAmount();
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

  cancelOrder({int? index}) {
    setState(() {
      if (index != null) {
        _cartItems.removeAt(index);
      } else {
        _cartItems.clear();
      }
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(left: 28),
            child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.arrow_back)),
          ),
          const Text(
            "Cart",
            style: TextStyle(
                fontFamily: 'poppins',
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: Color(0xff0a0b0a)),
          ),
          const Spacer(),
          const Padding(
            padding: EdgeInsets.only(right: 48.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 20,
            ),
          ),
        ],
        backgroundColor: const Color(0xffffffff),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                const SizedBox(
                  height: 32,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cartItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: const Color(0xffFFFFFF),
                      elevation: 0,
                      shape: BeveledRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.network(
                            'https://api.timbu.cloud/images/${_cartItems[index]['product'].photos[0].url}',
                            width: 87,
                            height: 98.26,
                          ),
                          Column(
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
                              const SizedBox(
                                height: 8,
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
                              const SizedBox(
                                height: 28,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    height: 24,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: const Color(0xffEAEAEA),
                                      ),
                                      borderRadius: BorderRadius.circular(1.83),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        IconButton(
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(
                                            Icons.remove,
                                            color: Colors.green,
                                            size: 12,
                                          ),
                                          onPressed: () =>
                                              _decrementQuantity(index),
                                        ),
                                        Text(
                                          '${_cartItems[index]['quantity'].toInt()}',
                                          style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'inter'),
                                        ),
                                        IconButton(
                                          padding: const EdgeInsets.all(0),
                                          icon: const Icon(
                                            Icons.add,
                                            color: Colors.green,
                                            size: 12,
                                          ),
                                          onPressed: () =>
                                              _incrementQuantity(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 6.75,
                                  ),
                                  Container(
                                    padding: EdgeInsets.zero,
                                    height: 26,
                                    width: 28,
                                    decoration: const BoxDecoration(
                                        color: Color(0xffCC474E)),
                                    child: Center(
                                      child: IconButton(
                                        icon: const Icon(
                                          Icons.delete_outline,
                                          size: 14,
                                          color: Color(0xffFFFFFF),
                                        ),
                                        onPressed: () {
                                          removeItem(index);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
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
                              const SizedBox(
                                height: 4,
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
                              const SizedBox(
                                height: 46,
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(
                  height: 48.74,
                ),
                Center(
                  child: Card(
                    color: const Color(0xffFEFEFE),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0xff408c2b))),
                    child: Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Text(
                            'Cart summary',
                            style: TextStyle(
                              fontFamily: 'lora',
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Color(0xff0a0b0a),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Sub-total",
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xff6E6E6E),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "$totalAmount",
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff6E6E6E),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 22,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  "Delivery",
                                  style: TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    color: Color(0xff6E6E6E),
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  "$deliveryFee",
                                  style: const TextStyle(
                                    fontFamily: 'poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Color(0xff6E6E6E),
                                  ),
                                )
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Divider(
                            color: Color(0xffcccbcb),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  cancelOrder();
                                },
                                style: OutlinedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 8, 0, 8),
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
                              const SizedBox(
                                width: 16,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Total Amount',
                                    style: TextStyle(
                                      color: Color(0xff797A7B),
                                      fontWeight: FontWeight.w400,
                                      fontFamily: 'poppins',
                                    ),
                                  ),
                                  Text(
                                    "₦${totalAmount + deliveryFee}",
                                    style: const TextStyle(
                                        color: Color(0xff363939),
                                        fontFamily: 'inter',
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                    padding:
                                        const EdgeInsets.fromLTRB(9, 8, 9, 8),
                                    backgroundColor: const Color(0xff408C2B),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(3.83))),
                                child: const Text(
                                  "Checkout",
                                  style: TextStyle(color: Color(0xffFAFAFA)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 59,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Row(
                  children: [
                    const Text(
                      "You might like",
                      style: TextStyle(
                        fontSize: 18,
                        color: Color(0xff363939),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'lora',
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        "View all",
                        style: TextStyle(
                            color: Color(0xff797A7B),
                            fontSize: 14,
                            fontFamily: 'inter',
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
                const Divider(),
                const SizedBox(
                  height: 48,
                ),
                FutureBuilder<ProductsResponse>(
                  future: products,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: Animatedloading(),
                      );
                    } else if (!snapshot.hasData ||
                        snapshot.data!.items.isEmpty) {
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
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
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
                                                        color:
                                                            Color(0xff797A7B)),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    "${prefix.currentprice.toString()}",
                                                    style: const TextStyle(
                                                        fontFamily: 'poppins',
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 14,
                                                        color:
                                                            Color(0xff363939)),
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
                                                            BorderRadius
                                                                .circular(4),
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
                                                        BorderRadius.circular(
                                                            6),
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
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
