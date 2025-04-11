import 'package:flutter/material.dart';
import 'package:mobile_final_project/model/game.dart'; // โมเดล Game
import 'package:mobile_final_project/game_detail/game_service.dart'; // ฟังก์ชันสำหรับเรียก API
import 'package:mobile_final_project/game_detail/game_info_section.dart'; // แสดงข้อมูลเกม

class GameDetail extends StatefulWidget {
  final String slug; // ตัวระบุเฉพาะของเกม
  const GameDetail({super.key, required this.slug});

  @override
  State<GameDetail> createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  bool isLoaded = false; // ตรวจสอบว่าข้อมูลโหลดเสร็จหรือยัง
  Game? game; // ข้อมูลของเกมที่ดึงมา
  String errorMessage = ''; // ข้อความ error ถ้ามี

  @override
  void initState() {
    super.initState();
    fetchData(); // โหลดข้อมูลเมื่อเปิดหน้า
  }

  // โหลดข้อมูลเกมโดยใช้ slug ที่ส่งเข้ามา
  Future<void> fetchData() async {
    try {
      final fetchedGame = await GameService.fetchGame(
        widget.slug,
      ); // เรียก API จาก GameService (รวม api หน้าเกม)
      setState(() {
        game = fetchedGame; // เก็บข้อมูลเกม
        isLoaded = true; // ตั้งสถานะว่าโหลดเสร็จ
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // ถ้า error ให้เก็บข้อความไว้แสดง
        isLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // คืนค่าเป็น Dialog ที่แสดงข้อมูลเกี่ยวกับเกมนั้นๆ
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(23),
        width: double.infinity,
        height:
            MediaQuery.of(context).size.height * 0.8, // ใช้ 80% ของความสูงจอ
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F39CF), Color(0xFF360A5A)],
            begin: Alignment.topCenter, // จุดเริ่มการไล่สี
            end: Alignment.bottomCenter, // จุดหยุดการไล่สี
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child:
            isLoaded && game != null
                ? GameInfoSection(
                  game: game,
                ) // ถ้าโหลดเสร็จและมีข้อมูลเกมให้แสดงรายละเอียดเกมขึ้นมา
                : buildLoadingOrError(), // ถ้ายังโหลดไม่เสร็จหรือ error ให้แสดง loading/error
      ),
    );
  }

  // แสดง loading หรือ error
  Widget buildLoadingOrError() => Center(
    child:
        errorMessage.isNotEmpty
            ? Text(errorMessage, style: const TextStyle(color: Colors.red))
            : const CircularProgressIndicator(),
  );
}
