import 'package:flutter/material.dart';
import 'package:shopsharrie/Screens/addtocart.dart';
import 'package:shopsharrie/model/productsdata.dart';

class Productdesc extends StatefulWidget {
  final Productsdata product;

  Productdesc({super.key, required this.product});

  @override
  State<Productdesc> createState() => _ProductdescState();
}

class _ProductdescState extends State<Productdesc> {
  List<Productsdata> cartItems = [];

  void addToCart(Productsdata product) {
    setState(() {
      cartItems.add(product);
    });
  }

  @override
  Widget build(BuildContext context) {
    var availableItem = widget.product.isAvailable;
    String availableText;
    if (availableItem == true) {
      availableText = 'In Stock';
    } else {
      availableText = 'Unavailable';
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Color(0xffE4F5E0),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
                padding: const EdgeInsets.only(left: 48.0),
                child: IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: Color(0xffFAFAFA),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back))),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(right: 48.0),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 20,
              ),
            ),
          ],
          // backgroundColor: const Color(0xffE4F5E0),
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    height: 435,
                    decoration: const BoxDecoration(color: Color(0xffE4F5E0)),
                  ),
                  Center(
                    child: Image.asset(
                      'lib/assets/images/backimg.png',
                      height: 279,
                      width: 284,
                    ),
                  ),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Image.network(
                        'https://api.timbu.cloud/images/${widget.product.photos[0].url}',
                        height: 220,
                        width: 220,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 8,
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of images per row
                  childAspectRatio: 1, // Adjust aspect ratio as needed
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: widget.product.photos.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    'https://api.timbu.cloud/images/${widget.product.photos[index].url}',
                    fit: BoxFit.cover,
                  );
                },
              ),
              const SizedBox(
                height: 64,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 48),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          widget.product.uniqueid,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Color(0xff6E6E6E),
                            fontFamily: 'poppins',
                          ),
                        ),
                        const Spacer(),
                        Text(
                          availableText,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color(0xff408C2B),
                            fontFamily: 'poppins',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                    Text(
                      widget.product.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0A0B0A),
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      widget.product.description.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff5A5A5A),
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "Made with perfection",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xff4EAB35),
                        fontFamily: 'poppins',
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.5),
                          child: Text(
                            "How to use",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff343434),
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.expand_more)
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Divider(
                        height: 1,
                        color: Color(0xffCCCBCB),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 2.5),
                          child: Text(
                            "Delivery and drop-off",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff343434),
                              fontFamily: 'poppins',
                            ),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.expand_more)
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Divider(
                        height: 1,
                        color: Color(0xffCCCBCB),
                      ),
                    ),
                    const SizedBox(height: 22),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: const Color(0xff408C2B),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'sub',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      '${widget.product.currentprice}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                OutlinedButton(
                  onPressed: () {
                    addToCart(widget.product);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Addtocart(
                                  product: widget.product,
                                  cartItems: [],
                                )));
                  },
                  style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xffFAFAFA)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.83))),
                  child: const Text(
                    "Add to cart",
                    style: TextStyle(color: Color(0xffFAFAFA)),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
