class Game {
  final String slug;
  final String name;
  final String released;
  final String imageBackground;
  final double rating;
  final int ratingTop;

  Game(
    this.slug,
    this.name,
    this.released,
    this.imageBackground,
    this.rating,
    this.ratingTop,
  );

  Game.fromJson(Map<String, dynamic> json)
    : slug = json['slug'],
      name = json['name'],
      released = json['released'],
      imageBackground = json['background_image'],
      rating = json['rating'],
      ratingTop = json['rating_top'];

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'released': released,
      'imageBackground': imageBackground,
      'rating': rating,
      'ratingTop': ratingTop,
    };
  }
}
