import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/main_template.dart';
import 'package:mobile_final_project/store/store_page.dart';
import 'package:mobile_final_project/Model/game_stores.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AllStores extends StatefulWidget {
  const AllStores({super.key});

  @override
  State<AllStores> createState() => _AllStoresState();
}

class _AllStoresState extends State<AllStores> {
  List<GameStores> stores = []; // เก็บรายการร้านค้า
  bool isLoaded = false; // เช็คสถานะโหลดข้อมูลเสร็จหรือยัง
  String errorMessage = ''; // เก็บข้อความ error ถ้ามี

  @override
  void initState() {
    super.initState();
    fetchData(); // เรียก API ทันทีเมื่อเปิดหน้า
  }

  // ฟังก์ชันดึงข้อมูลร้านค้าจาก RAWG API
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rawg.io/api/stores?key=09a0ff6332b442c3aae64869ed59163c',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          // แปลง JSON เป็น List ของ GameStores
          stores =
              (data['results'] as List)
                  .map((item) => GameStores.fromJson(item))
                  .toList();
          isLoaded = true; // โหลดสำเร็จ
        });
      } else {
        throw Exception("Failed to load data"); // โหลดไม่สำเร็จ
      }
    } catch (e) {
      // กรณีเกิด exception
      setState(() {
        errorMessage = e.toString();
        isLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      icon: Icons.store, // ไอคอนที่จะใช้ใน MainTemplate (icon)
      label: "Stores", // ชื่อที่จะใช้ใน MainTemplate (label)
      body: Column(
        children: [
          const SizedBox(height: 5),
          Expanded(child: _buildStoreList()), // แสดงรายการร้านค้า
        ],
      ),
    );
  }

  // สร้าง Widget แสดง Grid ของร้านค้า
  Widget _buildStoreList() {
    // กรณี error
    if (errorMessage.isNotEmpty) {
      return Center(child: Text(errorMessage));
    }

    // ระหว่างโหลดข้อมูล
    if (!isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    // แสดง GridView ของร้านค้า
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // แสดง 2 คอลัมน์
        crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
        mainAxisSpacing: 10, // ระยะห่างแนวตั้ง
        childAspectRatio: 3 / 2, // สัดส่วนของกรอบร้าน
      ),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return GestureDetector(
          onTap:
              () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => StorePage(
                        id: store.id,
                        name: store.name,
                        imageBackground: store.imageBackground,
                      ),
                ),
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
                  // แสดงภาพพื้นหลังร้านจาก URL
                  CachedNetworkImage(
                    imageUrl: store.imageBackground,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => Container(color: Colors.grey[300]),
                    errorWidget:
                        (context, url, error) =>
                            const Icon(Icons.error, color: Colors.red),
                  ),
                  // วางเลเยอร์สีดำทึบบนภาพ และแสดงชื่อร้าน
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        store.name,
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
