import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/model/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_final_project/game_detail/game_detail.dart';

class StorePage extends StatefulWidget {
  final int id;
  final String name, imageBackground;

  const StorePage({
    super.key,
    required this.id,
    required this.name,
    required this.imageBackground,
  });

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  int activeButtonIndex =
      0; // ตำแหน่งปุ่มที่ถูกเลือก (Top Sellers: 0, Free to Play: 1, Early Access: 2)
  List<Game> games = []; // รายชื่อเกมที่โหลดมาจาก API
  bool isLoaded = false; // สถานะว่าโหลดข้อมูลเสร็จหรือยัง
  String errorMessage = ''; // ข้อความแสดงข้อผิดพลาด

  @override
  void initState() {
    super.initState();
    fetchData(); // โหลดข้อมูลเกมที่ขายในหน้านั้นเมื่อหน้าถูกสร้าง
  }

  // ดึงข้อมูลเกมจาก RAWG API ตามร้านค้าที่เลือก
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rawg.io/api/games?key=09a0ff6332b442c3aae64869ed59163c&page_size=9&stores=${widget.id}',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            games =
                (data['results'] as List)
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.store, color: Colors.white),
            const SizedBox(width: 20),
            const Text(
              "Stores",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        leading: const BackButton(color: Colors.white),
      ),
      body: Stack(
        children: [
          // ภาพพื้นหลัง
          Positioned.fill(
            child: Image.asset("assets/bg.jpg", fit: BoxFit.cover),
          ),
          // ชั้นเบลอ
          _buildBlurLayer(size.height, 25, 55, 0.2),
          // เนื้อหาหลัก
          _buildMainLayer(size.width, size.height * 0.88),
        ],
      ),
    );
  }

  // สร้างชั้นเบลอแบบโค้ง
  Widget _buildBlurLayer(
    double height,
    double blur,
    double radius,
    double opacity,
  ) => Positioned(
    bottom: 0,
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: height,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 105, 70, 172).withOpacity(opacity),
            borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
          ),
        ),
      ),
    ),
  );
  // สร้างคอนเทนต์หลักที่อยู่เหนือชั้นเบลอ
  Widget _buildMainLayer(double width, double height) => Positioned(
    bottom: 0,
    child: ClipRRect(
      borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 105, 70, 172).withOpacity(0.1),
            borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              _buildHeader(width),
              const SizedBox(height: 25),
              _buildGameBanner(width * 0.9, height * 0.3),
              const SizedBox(height: 25),
              _buildButtonRow(),
              const SizedBox(height: 15),
              Expanded(child: _buildGameList()),
            ],
          ),
        ),
      ),
    ),
  );

  // แสดงหัวร้านค้าและไอคอน
  Widget _buildHeader(double width) => Row(
    children: [
      SizedBox(width: width * 0.03),
      Icon(Icons.gamepad_rounded, color: Colors.white, size: 40),
      const SizedBox(width: 20),
      Text(
        widget.name,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ],
  );

  // แสดงรูปภาพร้านค้า
  Widget _buildGameBanner(double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // โหลดภาพพื้นหลังร้าน
            CachedNetworkImage(
              imageUrl:
                  widget.imageBackground.isNotEmpty
                      ? widget.imageBackground
                      : "https://via.placeholder.com/400",
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[300]),
              errorWidget:
                  (context, url, error) =>
                      const Icon(Icons.error, color: Colors.red),
              fadeInDuration: const Duration(milliseconds: 500),
              fadeInCurve: Curves.easeIn,
            ),
            // เพิ่ม gradient ให้ตัวอักษรอ่านง่าย
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                ),
              ),
            ),
            // ใส่ข้อความทับไว้บนภาพ
            Positioned(
              bottom: 15,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Exclusive Deals Available",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // แถบปุ่มเลือกสถานะเกม
  Widget _buildButtonRow() {
    List<String> labels = ["Top Sellers", "Free to Play", "Early Access"];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        labels.length,
        (i) => _buildStatusButton(i, labels[i]),
      ),
    );
  }

  // จัดการปุ่มสถานะแต่ละอัน
  Widget _buildStatusButton(int index, String label) {
    bool isActive = activeButtonIndex == index;
    return TextButton(
      onPressed: () => setState(() => activeButtonIndex = index),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient:
              isActive
                  ? const LinearGradient(
                    colors: [Color(0xFF59CAFF), Color(0xFFE373FF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                  : null,
          color: isActive ? null : Colors.white.withOpacity(0.1),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.grey[400],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // แสดงรายการเกมในรูปแบบ Grid
  Widget _buildGameList() {
    if (!isLoaded) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
    }

    if (games.isEmpty) {
      return const Center(
        child: Text(
          "No games available.",
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      );
    }
    return GridView.builder(
      padding: EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // แสดง 2 คอลัมน์
        crossAxisSpacing: 10, // ระยะห่างระหว่างคอลัมน์
        mainAxisSpacing: 10, // ระยะห่างแนวตั้ง
        childAspectRatio: 3 / 2, // สัดส่วนของกรอบร้าน
      ),
      itemCount: games.length,
      itemBuilder: (context, index) {
        final game = games[index];
        // แสดง Dialog ข้อมูลของเกมที่เลือก
        return GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => GameDetail(slug: game.slug),
            );
          },
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // รูปภาพของเกม
                  CachedNetworkImage(
                    imageUrl: game.imageBackground,
                    fit: BoxFit.cover,
                    placeholder:
                        (context, url) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    errorWidget:
                        (context, url, error) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                  ),
                  // ชื่อเกม
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        game.name,
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
