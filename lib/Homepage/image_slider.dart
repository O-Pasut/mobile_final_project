import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/model/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({super.key});

  @override
  State<ImageSlider> createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  List<Game> games = []; // เก็บรายการเกมที่โหลดมา
  bool isLoaded = false; // ตรวจสอบว่าโหลดเสร็จหรือยัง
  String errorMessage = ''; // ใช้เก็บข้อความเมื่อเกิดข้อผิดพลาด

  @override
  void initState() {
    super.initState();
    fetchData(); // เรียกข้อมูลเกมเมื่อเริ่มต้นหน้า
  }

  // ฟังก์ชันโหลดข้อมูลเกมจาก RAWG API
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rawg.io/api/games?key=09a0ff6332b442c3aae64869ed59163c&page_size=7&stores=1',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            games =
                (data['results'] as List) // แปลงข้อมูล JSON เป็น Game
                    .map((item) => Game.fromJson(item))
                    .toList();
            isLoaded = true;
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoaded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.transparent,
      ),
      child:
          isLoaded
              // ใช้ AnotherCarousel เพื่อทำ ImageSlider
              ? AnotherCarousel(
                images:
                    games.map((game) {
                      return SizedBox(
                        width: double.infinity,
                        height: 250,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // รูปเกมแบบโหลดล่วงหน้าด้วย cached_network_image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: CachedNetworkImage(
                                imageUrl: game.imageBackground,
                                fit: BoxFit.cover,
                                placeholder:
                                    (context, url) => Container(
                                      height: 250,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: const Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                errorWidget:
                                    (context, url, error) => Container(
                                      height: 250,
                                      width: double.infinity,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.error, size: 50),
                                    ),
                              ),
                            ),

                            // ชื่อเกม + คะแนน อยู่ด้านล่างของภาพ
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: const BorderRadius.vertical(
                                    bottom: Radius.circular(20),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    // ชื่อเกม (ตัดข้อความถ้ายาวเกิน)
                                    Expanded(
                                      child: Text(
                                        game.name,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // แสดงคะแนน rating เกม
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.star,
                                          color: Colors.yellow,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          game.rating.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                showIndicator: false, // ไม่แสดงจุดบอกตำแหน่งของหน้าสไลด์
                borderRadius: true,
                radius: Radius.circular(20),
              )
              : const Center(
                child: CircularProgressIndicator(), // แสดงตัวหมุนโหลดข้อมูล
              ),
    );
  }
}
