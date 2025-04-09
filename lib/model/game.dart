class Game {
  final String slug;
  final String name;
  final String released;
  final String imageBackground;
  final double rating;
  final int ratingTop;
  String? description;
  int? playtime;
  int? metascore;
  List<String>? platforms;

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
      ratingTop = json['rating_top'],
      description =
          (json.containsKey('description_raw') &&
                  json['description_raw'] is String)
              ? json['description_raw']
              : null,
      playtime =
          (json.containsKey('playtime') && json['playtime'] is int)
              ? json['playtime']
              : null,
      metascore =
          (json.containsKey('metacritic') && json['metacritic'] is int)
              ? json['metacritic']
              : null,
      platforms =
          json['platforms'] != null
              ? (json['platforms'] as List)
                  .map((p) => p['platform']['name'].toString())
                  .toList()
              : null;

  Map<String, dynamic> toJson() {
    return {
      'slug': slug,
      'name': name,
      'released': released,
      'imageBackground': imageBackground,
      'rating': rating,
      'ratingTop': ratingTop,
      'description': description,
    };
  }
}
