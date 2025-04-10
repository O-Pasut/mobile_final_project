import 'package:flutter/material.dart';
import 'package:mobile_final_project/game_detail/game_service.dart';
import 'package:mobile_final_project/model/game.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';

class GameInfoSection extends StatefulWidget {
  final Game? game;

  const GameInfoSection({super.key, required this.game});
  @override
  State<GameInfoSection> createState() => _GameInfoSectionState();
}

class _GameInfoSectionState extends State<GameInfoSection> {
  bool isInDatabase = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final exists = await GameService.checkGameExists(widget.game!.slug);
      setState(() {
        isInDatabase = exists;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    }
  }

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
                child: Text(formatDate(widget.game!.released)),
              ),
              const Spacer(),
              Text(
                "AVERAGE PLAYTIME: ${widget.game!.playtime} HOURS",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            widget.game!.name,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: widget.game!.imageBackground,
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
            widget.game!.description ?? '',
            trimLines: 7,
            trimMode: TrimMode.Line,
            trimCollapsedText: "  Read more",
            trimExpandedText: "  Show less",
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white),
            moreStyle: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 206, 169, 255),
            ),
            lessStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 206, 169, 255),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Platforms", style: labelStyle()),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 80,
                    width: 200,
                    child: Text(
                      widget.game!.platforms!.join(', '),
                      style: const TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Metascore", style: labelStyle()),
                  const SizedBox(height: 5),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      border: Border.all(color: Colors.lightGreen),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      intCheck(widget.game?.metascore.toString()),
                      style: const TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Released Date", style: labelStyle()),
                  const SizedBox(height: 5),
                  SizedBox(
                    height: 50,
                    width: 200,
                    child: Text(
                      formatDate(widget.game!.released),
                      style: TextStyle(
                        color: Colors.lightGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: () async {
                  if (!isInDatabase) {
                    await GameService.addToFavourite(widget.game!);
                    fetchData();
                  } else {
                    await GameService.deleteFromFavourite(widget.game!.slug);
                    fetchData();
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
        ],
      ),
    );
  }

  String formatDate(String rawDate) =>
      DateFormat('MMM d, y').format(DateTime.parse(rawDate));

  TextStyle labelStyle() =>
      TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16);

  String intCheck(String? s) => (s ?? "N/A");
}
