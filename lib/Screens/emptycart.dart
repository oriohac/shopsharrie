import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopsharrie/Screens/animatedloading.dart';
import 'package:shopsharrie/Screens/home.dart';
import 'package:shopsharrie/model/productsdata.dart';
import 'package:http/http.dart' as http;

class EmptyCartScreen extends StatefulWidget {
  @override
  State<EmptyCartScreen> createState() => _EmptyCartScreenState();
  const EmptyCartScreen({super.key});
}

class _EmptyCartScreenState extends State<EmptyCartScreen> {
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
  @override
  void initState() {
    super.initState();
    products = getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [
          Spacer(),
          Padding(
            padding: EdgeInsets.only(right: 48.0),
            child: Icon(
              Icons.shopping_cart_outlined,
              size: 20,
            ),
          ),
        ],
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 0, 48, 48),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_cart_outlined,
                  size: 64,
                  color: Color(0xff408C2B),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your Cart is empty',
                  style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff0A0B0A),
                      fontFamily: 'lora'),
                ),
                const SizedBox(height: 16),
                const Text(
                  "Explore our collections today and start your journey towards radiant beauty. Your skin will thank you",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xff818181),
                    fontFamily: 'poppins',
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Home(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                      backgroundColor: const Color(0xff408C2B),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Start shopping',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xffffffff),
                        fontFamily: 'inter',
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
                                                padding:
                                                    const EdgeInsets.all(2),
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
                                                          color: Color(
                                                              0xff797A7B)),
                                                    ),
                                                    const SizedBox(height: 2),
                                                    Text(
                                                      '₦${prefix.currentprice.toString()}',
                                                      style: const TextStyle(
                                                          fontFamily: 'poppins',
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 14,
                                                          color: Color(
                                                              0xff363939)),
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.all(0),
                                                    backgroundColor:
                                                        Colors.white,
                                                    shape:
                                                        RoundedRectangleBorder(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
