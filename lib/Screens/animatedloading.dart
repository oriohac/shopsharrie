import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class Animatedloading extends StatelessWidget {
  const Animatedloading({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
          ),
          const SizedBox(height: 6.0),
          Container(
            width: double.infinity,
            height: 20.0,
            color: Colors.white,
          ),
          const SizedBox(height: 4.0),
          Container(
            width: 150.0,
            height: 7.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
