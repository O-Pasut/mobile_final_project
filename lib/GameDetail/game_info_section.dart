// game_info_section.dart
import 'package:flutter/material.dart';
import 'package:mobile_final_project/GameDetail/game_service.dart';
import 'package:mobile_final_project/model/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class GameInfoSection extends StatelessWidget {
  final Game? game;
  final bool isInDatabase;

  const GameInfoSection({
    super.key,
    required this.game,
    required this.isInDatabase,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(formatDate(game!.released)),
              ),
              const Spacer(),
              Text(
                "AVERAGE PLAYTIME: ${game!.playtime} HOURS",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            game!.name,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: game!.imageBackground,
              height: MediaQuery.of(context).size.height * 0.2,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "About",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          ReadMoreText(
            game!.description ?? '',
            trimLines: 7,
            trimMode: TrimMode.Line,
            trimCollapsedText: "  Read more",
            trimExpandedText: "  Show less",
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white),
            moreStyle: const TextStyle(fontSize: 14, color: Colors.purple),
            lessStyle: const TextStyle(fontSize: 14, color: Colors.purple),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              if (!isInDatabase) {
                await GameService.addToFavourite(game!);
              } else {
                await GameService.deleteFromFavourite(game!.slug);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isInDatabase ? Colors.green : null,
            ),
            child: Text(
              isInDatabase ? "Remove from Favourite" : "Add to Favourite",
            ),
          ),
        ],
      ),
    );
  }

  String formatDate(String rawDate) =>
      DateFormat('MMM d, y').format(DateTime.parse(rawDate));
}
