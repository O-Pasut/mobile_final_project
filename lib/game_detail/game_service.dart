import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/model/game.dart';

class GameService {
  static Future<Game> fetchGame(String slug) async {
    final res = await http.get(
      Uri.parse(
        'https://api.rawg.io/api/games/$slug?key=09a0ff6332b442c3aae64869ed59163c',
      ),
    );
    if (res.statusCode == 200) {
      return Game.fromJson(jsonDecode(res.body));
    } else {
      throw Exception('Failed to load game');
    }
  }

  static Future<bool> checkGameExists(String slug) async {
    final response = await http.get(
      Uri.parse("http://10.0.2.2:8001/games/exists/$slug"),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['exists'] == true;
    } else {
      throw Exception("Failed to check existence");
    }
  }

  static Future<void> addToFavourite(Game game) async {
    var response = await http.post(
      Uri.parse("http://10.0.2.2:8001/games"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(game.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception("Failed to add to favourite");
    }
  }

  static Future<void> deleteFromFavourite(String slug) async {
    final response = await http.delete(
      Uri.parse("http://10.0.2.2:8001/games/$slug"),
    );
    if (response.statusCode != 200) {
      throw Exception("Failed to remove from favourite");
    }
  }
}
