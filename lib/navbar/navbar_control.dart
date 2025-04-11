import 'package:flutter/material.dart';
import 'package:mobile_final_project/Navbar/navbar.dart';
import 'package:mobile_final_project/Store/all_stores.dart';
import 'package:mobile_final_project/Homepage/home_page.dart';
import 'package:mobile_final_project/favourite/favourite_page.dart';

class NavbarControl extends StatefulWidget {
  const NavbarControl({super.key});

  @override
  _NavbarControlState createState() => _NavbarControlState();
}

class _NavbarControlState extends State<NavbarControl> {
  int _selectedIndex =
      0; // เก็บ index ของหน้าทีเลือกอยู่ตอนนี้ (0 = Home, 1 = Stores, 2 = Favourite)

  final List<Widget> _pages = [
    const HomePage(), // หน้า Homepage
    const AllStores(), // หน้า Store
    FavouritePage(
      key: UniqueKey(),
    ), // หน้า Favourite (สร้างใหม่ด้วย key เพื่อให้สามารถ refresh เมื่อเลือกหน้านี้ได้)
  ];

  // set state ของหน้าที่ถูกเลือกเมื่อมีการเลือกใน navbar
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // ถ้าเลือกหน้า Favourite จะสร้างใหม่เพื่อ refresh ข้อมูลล่าสุด
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
          // แสดงหน้าแต่ละหน้าแบบ IndexedStack เพื่อรักษาสถานะของแต่ละหน้าไว้
          IndexedStack(index: _selectedIndex, children: _pages),

          // วาง Navbar ที่ตำแหน่งล่างของหน้าจอ
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
