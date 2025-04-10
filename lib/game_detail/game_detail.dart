import 'package:flutter/material.dart';
import 'package:mobile_final_project/game_detail/game_info_section.dart';
import 'package:mobile_final_project/model/game.dart';
import 'package:mobile_final_project/game_detail/game_service.dart';

class GameDetail extends StatefulWidget {
  final String slug;
  const GameDetail({super.key, required this.slug});

  @override
  State<GameDetail> createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  bool isLoaded = false;
  bool isInDatabase = false;
  Game? game;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final fetchedGame = await GameService.fetchGame(widget.slug);
      setState(() {
        game = fetchedGame;
        isLoaded = true;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoaded = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(23),
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7F39CF), Color(0xFF360A5A)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child:
            isLoaded && game != null
                ? GameInfoSection(game: game)
                : buildLoadingOrError(),
      ),
    );
  }

  Widget buildLoadingOrError() => Center(
    child:
        errorMessage.isNotEmpty
            ? Text(errorMessage, style: const TextStyle(color: Colors.red))
            : const CircularProgressIndicator(),
  );
}
