import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_final_project/game_detail.dart';
import '../model/game.dart';

class GameList extends StatefulWidget {
  final int startIndex;

  const GameList({super.key, required this.startIndex});

  @override
  State<GameList> createState() => _GameListState();
}

class _GameListState extends State<GameList> {
  List<Game> games = [];
  bool isLoaded = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://api.rawg.io/api/games?key=09a0ff6332b442c3aae64869ed59163c&page_size=8&stores=5',
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            games =
                (data['results'] as List)
                    .map((item) => Game.fromJson(item))
                    .toList();
            isLoaded = true;
          });
        }
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          errorMessage = e.toString();
          isLoaded = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 160,
          child:
              isLoaded
                  ? ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: games.length - widget.startIndex,
                    itemBuilder: (context, index) {
                      var game = games[index + widget.startIndex];
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 16),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) => GameDetail(slug: game.slug),
                            );
                          },

                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl: game.imageBackground,
                                  width: 120,
                                  height: 160,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  bottom: 0,
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    color: Colors.black.withOpacity(0.6),
                                    child: Text(
                                      game.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  )
                  : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(left: index == 0 ? 0 : 16),
                        child: Container(
                          width: 120,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child:
                                CircularProgressIndicator(), // Circle Loading
                          ),
                        ),
                      );
                    },
                  ),
        ),
      ],
    );
  }
}
