import 'package:flutter/material.dart';
import 'package:shopsharrie/Screens/cart.dart';
import 'package:shopsharrie/model/productsdata.dart';

class Addtocart extends StatelessWidget {
  final List<Productsdata> cartItems;
  final Productsdata product;
  const Addtocart({super.key, required this.product, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    var availableItem = product.isAvailable;
    String availableText;
    if (availableItem == true) {
      availableText = 'In Stock';
    } else {
      availableText = 'Unavailable';
    }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(color: Color(0xffE4F5E0)),
                ),
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Image.network(
                      'https://api.timbu.cloud/images/${product.photos[0].url}',
                      width: 100,
                      height: 100,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              height: MediaQuery.of(context).size.height *
                  0.25, // Adjust height as needed
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Number of images per row
                  childAspectRatio: 1, // Adjust aspect ratio as needed
                  crossAxisSpacing: 0,
                  mainAxisSpacing: 0,
                ),
                itemCount: product.photos.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    'https://api.timbu.cloud/images/${product.photos[index].url}',
                    fit: BoxFit.cover,
                  );
                },
              ),
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
                        product.uniqueid,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                          color: Color(0xff6E6E6E),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        availableText,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff408C2B),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0A0B0A)),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    product.description.toString(),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff5A5A5A),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "Made with perfection",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xff4EAB35),
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
        color: const Color(0xffCAECC0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(48, 4, 48, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
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
                    'Unit price',
                    style: TextStyle(color: Color(0xff313434)),
                  ),
                  Text(
                    '${product.currentprice}',
                    style: const TextStyle(color: Color(0xff363939)),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cart(cartItems: cartItems),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
                    backgroundColor: const Color(0xff408C2B),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.83))),
                child: const Text(
                  "Checkout",
                  style: TextStyle(color: Color(0xffFAFAFA)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
