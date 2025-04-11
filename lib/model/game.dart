class Game {
  // ข้อมูลหลักของเกม
  final String slug; // ใช้สำหรับระบุเกมใน URL
  final String name; // ชื่อเกม
  final String released; // วันที่ปล่อยเกม
  final String imageBackground; // ลิงก์ภาพพื้นหลัง
  final double rating; // คะแนน rating ของเกม

  // ข้อมูลเพิ่มเติม (อาจเป็น null ได้)
  String? description; // รายละเอียดเกม
  int? playtime; // เวลาเฉลี่ยที่ใช้เล่นเกม (ชั่วโมง)
  int? metascore; // คะแนน Metacritic
  List<String>? platforms; // รายชื่อแพลตฟอร์ม

  Game(this.slug, this.name, this.released, this.imageBackground, this.rating);

  // method สำหรับแปลง JSON เป็น Game object
  Game.fromJson(Map<String, dynamic> json)
    : slug = json['slug'],
      name = json['name'],
      released = json['released'],
      imageBackground = json['background_image'],
      rating = json['rating'],
      // ตรวจสอบว่ามี key และเป็น String หรือไม่
      description =
          (json.containsKey('description_raw') &&
                  json['description_raw'] is String)
              ? json['description_raw']
              : null,
      // ตรวจสอบว่า playtime เป็น int หรือไม่
      playtime =
          (json.containsKey('playtime') && json['playtime'] is int)
              ? json['playtime']
              : null,
      // ตรวจสอบว่า metascore เป็น int หรือไม่
      metascore =
          (json.containsKey('metacritic') && json['metacritic'] is int)
              ? json['metacritic']
              : null,
      // แปลง platforms ให้กลายเป็น List<String>
      platforms =
          json['platforms'] != null
              ? (json['platforms'] as List)
                  .map((p) => p['platform']['name'].toString())
                  .toList()
              : null;

  // method แปลง Game object กลับเป็น JSON
  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'released': released,
      'imageBackground': imageBackground,
      'rating': rating,
    };
  }
}
