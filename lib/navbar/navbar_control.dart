import 'package:flutter/material.dart';
import 'package:mobile_final_project/home_page.dart';
import 'package:mobile_final_project/navbar/navbar.dart';
import 'package:mobile_final_project/favourite_page.dart';
import 'package:mobile_final_project/Store/all_stores.dart';

class NavbarControl extends StatefulWidget {
  const NavbarControl({super.key});

  @override
  _NavbarControlState createState() => _NavbarControlState();
}

class _NavbarControlState extends State<NavbarControl> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const HomePage(),
    const AllStores(),
    const FavouritePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Use IndexedStack to preserve page state and prevent rebuilding
          IndexedStack(index: _selectedIndex, children: _pages),
          Positioned(
            bottom: 0,
            child: Navbar(
              width: screenSize.width,
              height: screenSize.height,
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
