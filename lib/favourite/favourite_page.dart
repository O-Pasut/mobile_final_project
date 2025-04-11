import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/game_detail/game_detail.dart';
import 'package:mobile_final_project/main_template.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<dynamic> games = []; // เก็บรายการเกมที่โหลดมาจาก database
  bool isLoaded = false; // ใช้ตรวจสอบสถานะการโหลดข้อมูล

  @override
  void initState() {
    super.initState();
    fetchFavourite(); // เรียกข้อมูลเกมจาก database เมื่อเข้ามาที่หน้านี้
  }

  // ดึงข้อมูลเกมที่ถูก favourite เอาไว้จาก database
  Future<void> fetchFavourite() async {
    setState(() => isLoaded = false); // ตั้งสถานะเป็นกำลังโหลด
    try {
      final res = await http.get(Uri.parse('http://10.0.2.2:8001/games'));
      if (res.statusCode == 200) {
        setState(() {
          games = jsonDecode(res.body); // แปลง JSON เป็น list
          isLoaded = true; // ตั้งสถานะว่าโหลดเสร็จแล้ว
        });
      } else {
        throw Exception("Failed to load games");
      }
    } catch (_) {
      // กรณีมีข้อผิดพลาดก็ให้แสดงหน้าว่าง (ไม่ error)
      setState(() => isLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) => MainTemplate(
    icon: Icons.star,
    label: "Favourites",
    body: Column(children: [Expanded(child: _buildGameList())]),
  );

  // แสดงรายการเกมแบบตาราง
  Widget _buildGameList() {
    // ถ้ากำลังโหลด แสดง loading ด้วย CircularProgressIndicator
    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    // ถ้าไม่มีเกมใน database (Favourite ไว้) ให้แสดงข้อความ "No games available.",
    if (games.isEmpty) {
      return const Center(
        child: Text(
          "No games available.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }

    // สร้าง Grid แสดงรายการเกมทั้งหมดที่ดึงมา
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // จำนวนคอลัมน์
        crossAxisSpacing: 10, // ระยะห่างแนวนอน
        mainAxisSpacing: 10, // ระยะห่างแนวตั้ง
        childAspectRatio: 3 / 2, // อัตราส่วนของแต่ละช่อง
      ),
      itemCount: games.length,
      itemBuilder: (context, i) {
        final game = games[i];
        return GestureDetector(
          // เมื่อกดที่รายการเกม จะให้แสดง popup รายละเอียดของเกมนั้น
          onTap:
              () => showDialog(
                context: context,
                builder: (_) => GameDetail(slug: game['slug']),
              ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // โหลดภาพพื้นหลังของเกม
                  CachedNetworkImage(
                    imageUrl: game['imageBackground'] ?? '',
                    fit: BoxFit.cover,
                    placeholder:
                        (_, __) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    errorWidget:
                        (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                  ),
                  // แสดงชื่อเกมเอาไว้บนภาพ
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        game['name'] ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
