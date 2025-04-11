import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:mobile_final_project/model/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_final_project/game_detail/game_service.dart';

class GameInfoSection extends StatefulWidget {
  final Game? game;

  const GameInfoSection({super.key, required this.game});
  @override
  State<GameInfoSection> createState() => _GameInfoSectionState();
}

class _GameInfoSectionState extends State<GameInfoSection> {
  bool isInDatabase =
      false; // ตรวจสอบว่าเกมนี้อยู่ในฐานข้อมูล (favourite) หรือยัง
  String errorMessage = ''; // เก็บข้อความ error ถ้าเกิดข้อผิดพลาด

  @override
  void initState() {
    super.initState();
    fetchData(); // เรียกฟังก์ชันตรวจสอบสถานะเกมในฐานข้อมูลเมื่อ widget ถูกสร้าง
  }

  // ฟังก์ชันเรียก API เพื่อตรวจสอบว่าเกมอยู่ใน favourite หรือยัง
  Future<void> fetchData() async {
    try {
      final exists = await GameService.checkGameExists(widget.game!.slug);
      setState(() {
        isInDatabase = exists;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString(); // ถ้า error เก็บข้อความไว้
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // ใช้ ScrollView เพื่อให้เลื่อนดูข้อมูลได้
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // แถวแรก: วันที่เปิดตัวเกมครั้งแรก และเวลาเล่นเฉลี่ย
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(formatDate(widget.game!.released)),
              ),
              const Spacer(),
              Text(
                "AVERAGE PLAYTIME: ${widget.game!.playtime} HOURS",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // ชื่อเกม
          Text(
            widget.game!.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),

          // รูปพื้นหลังเกม
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: widget.game!.imageBackground,
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),

          // หัวข้อ About (คำอธิบายเกี่ยวกับเกม)
          const Text(
            "About",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),

          // คำอธิบายเกม แบบย่อ / ขยายได้
          ReadMoreText(
            widget.game!.description ?? '',
            trimLines: 7, // ตัดข้อความให้เริ่มต้นอยู่ที่ 7 บรรทัด
            trimMode: TrimMode.Line,
            trimCollapsedText:
                "  Read more", // ข้อความที่แสดงเพื่อต้องการอ่านเพิ่ม
            trimExpandedText:
                "  Show less", // ข้อความที่แสดงเพื่อย่อกลับไปเหลือเท่าเดิม
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white),
            moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 206, 169, 255),
            ),
            lessStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 206, 169, 255),
            ),
          ),
          const SizedBox(height: 20),

          // ข้อมูล platforms และ metascore
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Platforms", style: labelStyle()),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 80,
                    width: 200,
                    child: Text(
                      widget.game!.platforms!.join(', '),
                      style: const TextStyle(
                        color: Colors.lightGreenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Metascore", style: labelStyle()),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.lightGreenAccent),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      intCheck(widget.game?.metascore.toString()),
                      style: const TextStyle(
                        color: Colors.lightGreenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // วันที่เปิดตัวเกมครั้งแรก
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Released Date", style: labelStyle()),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: Text(
                      formatDate(widget.game!.released),
                      style: TextStyle(
                        color: Colors.lightGreenAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // ปุ่ม Add / Remove จาก Favourite
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // ถ้ายังไม่อยู่ใน database -> เพิ่มเข้าไป
                  if (!isInDatabase) {
                    await GameService.addToFavourite(widget.game!);
                    fetchData(); // รีเฟรชสถานะหลังเพิ่ม
                  } else {
                    // ถ้าอยู่แล้ว -> ลบออก
                    await GameService.deleteFromFavourite(widget.game!.slug);
                    fetchData(); // รีเฟรชสถานะหลังลบ
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isInDatabase ? Colors.lightGreenAccent : null,
                ),
                child: Text(
                  isInDatabase ? "Remove from Favourite" : "Add to Favourite",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // แปลงวันที่เป็น format ที่ต้องการ เช่น Apr 10, 2025
  String formatDate(String rawDate) =>
      DateFormat('MMM d, y').format(DateTime.parse(rawDate));

  // TextStyle ที่ใช้เหมือนกัน เช่น Platforms, Metascore
  TextStyle labelStyle() =>
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);

  // ตรวจสอบว่าเป็นเลขจริงหรือไม่ ถ้า null ให้แสดง "N/A"
  String intCheck(String? s) => (s ?? "N/A");
}
