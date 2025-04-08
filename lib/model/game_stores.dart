class GameStores {
  final int id;
  final String name;
  final String imageBackground;

  GameStores(this.id, this.name, this.imageBackground);

  GameStores.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      imageBackground = json['image_background'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'imageBackground': imageBackground};
  }
}
