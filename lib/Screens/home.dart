import 'dart:convert';
import 'dart:math';

import 'package:cupertino_icons/cupertino_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopsharrie/Screens/animatedloading.dart';
import 'package:shopsharrie/Screens/cart.dart';
import 'package:shopsharrie/Screens/emptycart.dart';
import 'package:shopsharrie/Screens/productdesc.dart';
import 'package:shopsharrie/model/productsdata.dart';
import 'package:http/http.dart' as http;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
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

  late Future<ProductsResponse> products;
  ScrollController scrollController = ScrollController();
  bool atStart = true;
  bool atEnd = false;

  void scrollLeft() {
    scrollController.animateTo(
      scrollController.offset - 50,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  void scrollRight() {
    scrollController.animateTo(
      scrollController.offset + 50,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  void initState() {
    super.initState();
    products = getProducts();
    scrollController.addListener(() {
      setState(() {
        atStart = scrollController.offset <= 0;
        atEnd = scrollController.position.maxScrollExtent ==
            scrollController.offset;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: const [
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: Center(
              child: Text(
                "Sharrie's Signature",
                style: TextStyle(
                  color: Color(0xff408C2B),
                  fontFamily: 'redressed',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(Icons.shopping_cart_outlined),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome, Jane',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w400,
                  color: Color(0xff0A0B0A),
                ),
              ),
              const TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Search',
                  hintStyle: TextStyle(
                      color: Color(0xffB1B2B2),
                      fontFamily: 'inter',
                      fontSize: 16),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffD2D3D3)),
                    borderRadius: BorderRadius.all(
                      Radius.circular(6),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  const Text(
                    "Just for you",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'lora',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff363939),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new),
                    color: atStart ? Colors.grey : Colors.black,
                    onPressed: atStart ? null : scrollLeft,
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                    color: atEnd ? Colors.grey : Colors.black,
                    onPressed: atEnd ? null : scrollRight,
                  ),
                ],
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
                    return const Center(
                      child: Text('No products found'),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    final random = Random();
                    final List<Productsdata> items =
                        List.from(snapshot.data!.items);
                    items.shuffle(random);
                    const int subsetLength = 5;
                    final List<Productsdata> randomSubset =
                        items.take(subsetLength).toList();
                    return SizedBox(
                      height: 200,
                      child: ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: randomSubset.length,
                        itemBuilder: (context, index) {
                          var prefix = randomSubset[index];
                          return Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EmptyCartScreen()));
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(2)),
                                  elevation: 0,
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Column(
                                      children: [
                                        Expanded(
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: prefix.photos.isNotEmpty
                                                ? Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(
                                                      2,
                                                      2,
                                                      2,
                                                      2,
                                                    ),
                                                    child: Image.network(
                                                      'https://api.timbu.cloud/images/${prefix.photos[0].url}',
                                                    ),
                                                  )
                                                : Container(),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 4,
                                        ),
                                        Row(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  prefix.name,
                                                  maxLines: 3,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  textAlign: TextAlign.start,
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff797A7B),
                                                  ),
                                                ),
                                                Text(
                                                  '₦${prefix.currentprice.toString()}',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xff363939),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 12,
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
                                                          "check it in your cart"),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
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
                                                        color:
                                                            Color(0xff408c2b)),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            2.37),
                                                  ),
                                                ),
                                                child: const Text(
                                                  'Add to Cart',
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 7.1,
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff408c2b),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
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
                },
              ),
              Row(
                children: [
                  const Text(
                    "Deals",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: 'lora',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff363939),
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'inter',
                        fontWeight: FontWeight.w500,
                        color: Color(0xff797a7b),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(
                color: Color(0xffcccbcb),
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
                    return SizedBox(
                      height: 500,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (context, index) {
                          var prefix = snapshot.data!.items[index];

                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Productdesc(product: prefix),
                                ),
                              );
                            },
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
                                                      fontSize: 10,
                                                      fontFamily: 'poppins',
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: Color(0xff797a7b),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    '₦${prefix.currentprice.toString()}',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontFamily: 'poppins',
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color(0xff363939),
                                                    ),
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
                      ),
                    );
                  }
                },
              ),
              const Text(
                "Our Collections",
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'poppins',
                  fontWeight: FontWeight.w300,
                  color: Color(0xff0a0b0a),
                ),
              ),
              const Divider(color: Color(0xffcccbcb)),
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
                    return SizedBox(
                      height: 500,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: snapshot.data!.items.length,
                        itemBuilder: (context, index) {
                          var prefix = snapshot.data!.items[index];

                          return Card(
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
                                                  textAlign: TextAlign.center,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontFamily: 'poppins',
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff0a0b0a),
                                                  ),
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
                          );
                        },
                      ),
                    );
                  }
                },
              ),
              const Row(
                children: [
                  Text(
                    "You might like",
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'lora',
                      fontWeight: FontWeight.w600,
                      color: Color(0xff363939),
                    ),
                  ),
                  Spacer(),
                  Text("View all"),
                ],
              ),
              const Divider(),
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
                    const int subsetLength = 6;
                    final List<Productsdata> randomSubset =
                        items.take(subsetLength).toList();
                    return SizedBox(
                      height: 500,
                      child: GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                        itemCount: randomSubset.length,
                        itemBuilder: (context, index) {
                          var prefix = randomSubset[index];

                          return Card(
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
                                                  style: const TextStyle(),
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  '₦${prefix.currentprice.toString()}',
                                                  style: const TextStyle(),
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
                          );
                        },
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
