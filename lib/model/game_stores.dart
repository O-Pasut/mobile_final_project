import 'package:mobile_final_project/model/games.dart';

class GameStores {
  final int id;
  final String name;
  final String domain;
  final String slug;
  final int gamesCount;
  final String imageBackground;
  final List<Games> games;

  GameStores(
    this.id,
    this.name,
    this.domain,
    this.slug,
    this.gamesCount,
    this.imageBackground,
    this.games,
  );

  GameStores.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      name = json['name'],
      domain = json['domain'],
      slug = json['slug'],
      gamesCount = json['games_count'],
      imageBackground = json['image_background'],
      games =
          (json['games'] as List).map((game) => Games.fromJson(game)).toList();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'domain': domain,
      'slug': slug,
      'gamesCount': gamesCount,
      'imageBackground': imageBackground,
      'games': games.map((game) => game.toJson()).toList(),
    };
  }
}
