class GameStores {
  final int id; // รหัสร้านค้า
  final String name; // ชื่อร้านค้า เช่น Steam, Epic Games
  final String imageBackground; // URL ภาพพื้นหลังของร้านค้านั้น

  GameStores(this.id, this.name, this.imageBackground);

  // method แปลง JSON -> GameStores object
  GameStores.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      imageBackground = json['image_background'];

  // method แปลง GameStores object -> JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageBackground': imageBackground};
  }
}
