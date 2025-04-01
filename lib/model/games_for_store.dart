class GamesForStore {
  final String slug;
  final String name;
  final int playTime;
  final String released;
  final String imageBackground;
  final double rating;
  final int ratingTop;

  GamesForStore(
    this.slug,
    this.name,
    this.playTime,
    this.released,
    this.imageBackground,
    this.rating,
    this.ratingTop,
  );

  GamesForStore.fromJson(Map<String, dynamic> json)
    : slug = json['slug'],
      name = json['name'],
      playTime = json['playtime'],
      released = json['released'],
      imageBackground = json['background_image'],
      rating = json['rating'],
      ratingTop = json['rating_top'];

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'playTime': playTime,
      'released': released,
      'imageBackground': imageBackground,
      'rating': rating,
      'ratingTop': ratingTop,
    };
  }
}
