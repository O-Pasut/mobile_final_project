import 'package:flutter/material.dart';
import 'package:mobile_final_project/Homepage/home_page.dart';
import 'package:mobile_final_project/Navbar/navbar.dart';
import 'package:mobile_final_project/favourite/favourite_page.dart';
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
    FavouritePage(key: UniqueKey()), // Use key to rebuild when selected
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // If FavouritePage is selected, rebuild it by giving a new UniqueKey
      if (index == 2) {
        _pages[2] = FavouritePage(key: UniqueKey());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
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
