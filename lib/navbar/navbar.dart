import 'dart:ui';
import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final double width;
  final double height;
  final int selectedIndex;
  final Function(int) onItemTapped;
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
      bottom: 0,
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: width,
            height: height * 0.08,
            decoration: BoxDecoration(
              color: const Color.fromARGB(118, 112, 41, 170),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavIcon(Icons.festival_rounded, "Home", 0),
                _buildNavIcon(Icons.store, "Stores", 1),
                _buildNavIcon(Icons.star, "Favourite", 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, String label, int index) {
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onItemTapped(index),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
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
