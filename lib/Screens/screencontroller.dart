import 'package:flutter/material.dart';
import 'package:shopsharrie/Screens/home.dart';
import 'package:shopsharrie/Screens/profile.dart';
import 'package:shopsharrie/Screens/search.dart';
import 'package:shopsharrie/Screens/wishlist.dart';

class Screencontroller extends StatefulWidget {
  const Screencontroller({super.key});

  @override
  State<Screencontroller> createState() => _ScreencontrollerState();
}

class _ScreencontrollerState extends State<Screencontroller> {
  //initiial screen of the BottomNavigation
  int selectedScreen = 0;
// function to update the screen according to what's selected in the BottomNavigation
  void currentScreen(int state) {
    setState(() {
      selectedScreen = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    List screens = [
      const Home(),
      const Wishlist(),
      const Profile(),
      const Search(),
    ];
    return Scaffold(
      body: screens[selectedScreen],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xffFFFFFF),
        selectedItemColor: const Color(0xff1F2223),
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontSize: 10,),
        unselectedLabelStyle: const TextStyle(fontSize: 10,),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        currentIndex: selectedScreen,
        onTap: currentScreen,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined,), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border), label: 'Wishlist'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outlined), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        ],
      ),
    );
  }
}
