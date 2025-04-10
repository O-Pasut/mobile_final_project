import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mobile_final_project/game_detail/game_detail.dart';
import 'package:mobile_final_project/main_template.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  List<dynamic> games = [];
  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchFavourite();
  }

  Future<void> fetchFavourite() async {
    setState(() => isLoaded = false);
    try {
      final res = await http.get(Uri.parse('http://10.0.2.2:8001/games'));
      if (res.statusCode == 200) {
        setState(() {
          games = jsonDecode(res.body);
          isLoaded = true;
        });
      } else {
        throw Exception("Failed to load games");
      }
    } catch (_) {
      setState(() => isLoaded = true);
    }
  }

  @override
  Widget build(BuildContext context) => MainTemplate(
    icon: Icons.star,
    label: "Favourites",
    body: Column(children: [Expanded(child: _buildGameList())]),
  );

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
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
      itemCount: games.length,
      itemBuilder: (context, i) {
        final game = games[i];
        return GestureDetector(
          onTap:
              () => showDialog(
                context: context,
                builder: (_) => GameDetail(slug: game['slug']),
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
                  CachedNetworkImage(
                    imageUrl: game['imageBackground'] ?? '',
                    fit: BoxFit.cover,
                    placeholder:
                        (_, __) => const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        ),
                    errorWidget:
                        (_, __, ___) => Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error, color: Colors.red),
                        ),
                  ),
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: Text(
                        game['name'] ?? '',
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
