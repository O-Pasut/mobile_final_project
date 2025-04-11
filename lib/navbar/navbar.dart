import 'dart:ui';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final double width; // ความกว้างของ navbar
  final double height; // ความสูงของ navbar
  final int selectedIndex; // ตำแหน่งที่ถูกเลือกใน navbar
  final Function(int) onItemTapped; // ฟังก์ชันที่เรียกเมื่อกดปุ่มใน navbar

  const Navbar({
    super.key,
    required this.width,
    required this.height,
    required this.selectedIndex,
    required this.onItemTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0, // วางไว้ด้านล่างของหน้าจอ (สูงจากด้านล่างมา 0)
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // เบลอภาพพื้นหลัง
          child: Container(
            width: width,
            height: height * 0.08, // กำหนดความสูง navbar
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                118,
                112,
                41,
                170,
              ), // สีพื้นแบบโปร่งใส
            ),
            child: Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceAround, // จัดเรียง icon ให้เว้นห่างเท่ากัน
              children: [
                _buildNavIcon(Icons.festival_rounded, "Home", 0), // หน้า Home
                _buildNavIcon(Icons.store, "Stores", 1), // หน้า Store
                _buildNavIcon(Icons.star, "Favourite", 2), // หน้า Favourite
              ],
            ),
          ),
        ),
      ),
    );
  }

  // สร้างไอคอนสำหรับแต่ละปุ่มใน navbar
  Widget _buildNavIcon(IconData icon, String label, int index) {
    bool isSelected =
        selectedIndex ==
        index; // ตรวจสอบว่าหน้านี้ถูกเลือกหรือไม่ เทียบจาก index ของหน้าที่ถูกเลือก

    return GestureDetector(
      onTap: () => onItemTapped(index), // เรียกหน้าตามปุ่มที่กด
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          // ถ้าปุ่มที่ถูกเลือกอยู่ จะแสดง gradient ให้เห็น
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [Color(0xFF6A47AC), Color(0xFFCC4B58)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 25),
            Text(
              label,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
