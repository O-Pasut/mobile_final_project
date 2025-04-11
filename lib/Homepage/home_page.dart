import 'package:flutter/material.dart';
import 'package:mobile_final_project/main_template.dart';
import 'package:mobile_final_project/homepage/game_list.dart';
import 'package:mobile_final_project/homepage/image_slider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // ใช้ MainTemplate เพื่อวาง layout หลักของหน้า
    return MainTemplate(body: _homepageBody());
  }

  // ฟังก์ชันสร้างเนื้อหาหลักของหน้า HomePage
  Widget _homepageBody() {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แสดงสไลด์รูปภาพด้านบน
          ImageSlider(),
          SizedBox(height: 20),

          // หัวข้อ Trending Games
          const Text(
            "Trending Games",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),

          // แสดงเกมที่กำลังมาแรง (เริ่มจาก index 0)
          GameList(startIndex: 0),
          SizedBox(height: 20),

          // หัวข้อ Recommend
          const Text(
            "Recommend",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),

          // แสดงเกมแนะนำ (เลือกเกมตั้งแต่ index 3 เป็นต้นไป)
          GameList(startIndex: 3),
        ],
      ),
    );
  }
}
