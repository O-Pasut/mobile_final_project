import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/model/game.dart';

class GameService {
  // ดึงข้อมูลเกมจาก RAWG API โดยใช้ slug (ชื่อเฉพาะของเกม)
  static Future<Game> fetchGame(String slug) async {
    final res = await http.get(
      Uri.parse(
        'https://api.rawg.io/api/games/$slug?key=09a0ff6332b442c3aae64869ed59163c',
      ),
    );
    if (res.statusCode == 200) {
      return Game.fromJson(jsonDecode(res.body)); // แปลง JSON เป็น object Game
    } else {
      throw Exception(
        'Failed to load game',
      ); // แสดง error ถ้าข้อมูลถูกโหลดไม่สำเร็จ
    }
  }

  // ตรวจสอบว่าเกมมีอยู่ในฐานข้อมูลภายในของเราแล้วหรือยัง
  static Future<bool> checkGameExists(String slug) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8001/games/exists/$slug"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body); // แปลง JSON เป็น map
      return data['exists'] == true; // คืนค่า true ถ้าเกมมีอยู่
    } else {
      throw Exception("Failed to check existence"); // กรณีเรียก API ไม่สำเร็จ
    }
  }

  // เพิ่มเกมลงในรายการ Favourite (ส่งข้อมูลเกมแบบ JSON ไปยัง database ภายใน)
  static Future<void> addToFavourite(Game game) async {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:8001/games"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(game.toJson()), // แปลง object Game เป็น JSON
    );
    if (response.statusCode != 201) {
      throw Exception(
        "Failed to add to favourite",
      ); // แสดง error ถ้าเพิ่มเข้า database ไม่สำเร็จ
    }
  }

  // ลบเกมออกจากรายการ Favourite โดยใช้ slug ของเกม
  static Future<void> deleteFromFavourite(String slug) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8001/games/$slug"),
    );
    if (response.statusCode != 200) {
      throw Exception(
        "Failed to remove from favourite",
      ); // แสดง error ถ้าลบข้อมูลจาก database ไม่สำเร็จ
    }
  }
}
