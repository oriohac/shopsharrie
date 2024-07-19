import 'package:flutter/material.dart';
import 'package:shopsharrie/Screens/cart.dart';
import 'package:shopsharrie/model/productsdata.dart';

class Addtocart extends StatefulWidget {
  final List<Productsdata> cartItems;
  final Productsdata product;
  const Addtocart({super.key, required this.product, required this.cartItems});

  @override
  State<Addtocart> createState() => _AddtocartState();
}

class _AddtocartState extends State<Addtocart> {
  int _counter = 0;
   void _incrementCounter() {
    setState(() {
      _counter++;
    },);
  }
   void _decrementCounter() {
    setState(() {
      _counter--;
    },
    );
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
                      'https://api.timbu.cloud/images/${widget.product.photos[0].url}',
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
                itemCount: widget.product.photos.length,
                itemBuilder: (context, index) {
                  return Image.network(
                    'https://api.timbu.cloud/images/${widget.product.photos[index].url}',
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

                  Container(
      decoration: BoxDecoration(
        border: Border.all(color: Color(0xffEAEAEA),),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.remove, color: Colors.green),
            onPressed: _decrementCounter,
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(color: Color(0xffEAEAEA),),),
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$_counter',
              style: TextStyle(fontSize: 20),
            ),
          ),
          IconButton(
            icon: Icon(Icons.add, color: Colors.green),
            onPressed: _incrementCounter,
          ),
        ],
      ),
    ),

    SizedBox(height: 16,),
                ],
              ),
            ),
            
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color(0xffCAECC0),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(38, 4, 38, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    'Unit price',
                    style: TextStyle(
                      color: Color(0xff797A7B),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'poppins',
                    ),
                  ),
                  Text(
                    'N${widget.product.currentprice}',
                    style: const TextStyle(
                      color: Color(0xff363939),
                      fontFamily: 'inter',
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cart(cartItems: widget.cartItems),
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
