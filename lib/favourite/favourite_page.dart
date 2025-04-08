import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoaded = false;
    });
    try {
      var response = await http.get(Uri.parse('http://10.0.2.2:8001/games'));
      if (response.statusCode == 200) {
        setState(() {
          games = jsonDecode(response.body);
          isLoaded = true;
        });
      } else {
        throw Exception("Failed to load games");
      }
    } catch (e) {
      print(e);
      setState(() {
        isLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainTemplate(
      icon: Icons.star,
      label: "Favourites",
      body: _favouriteBody(),
    );
  }

  Widget _favouriteBody() {
    return Column(children: [Expanded(child: _buildGameList())]);
  }

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
      itemBuilder: (context, index) {
        final game = games[index];
        return GestureDetector(
          onTap: () => print("Clicked on ${game['slug']}"),
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
