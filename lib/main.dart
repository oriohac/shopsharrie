import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shopsharrie/Screens/home.dart';
import 'package:shopsharrie/Screens/screencontroller.dart';
import 'package:shopsharrie/model/productsdata.dart';

Future<void> main() async {
  if (kReleaseMode) {
    await dotenv.load(fileName: ".env.prod");
  } else {
    await dotenv.load(fileName: ".env");
  }

  runApp(const Shopsharrie());
}

class Shopsharrie extends StatelessWidget {
  const Shopsharrie({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Screencontroller(),
      
    );
  }
}
