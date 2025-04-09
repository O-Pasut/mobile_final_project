import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:mobile_final_project/model/game.dart';

class GameDetail extends StatefulWidget {
  final String slug;
  const GameDetail({super.key, required this.slug});

  @override
  State<GameDetail> createState() => _GameDetailState();
}

class _GameDetailState extends State<GameDetail> {
  bool isLoaded = false;
  Game? game;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final res = await http.get(
        Uri.parse(
          'https://api.rawg.io/api/games/${widget.slug}?key=09a0ff6332b442c3aae64869ed59163c',
        ),
      );
      if (res.statusCode == 200) {
        setState(() {
          game = Game.fromJson(jsonDecode(res.body));
          isLoaded = true;
        });
      } else {
        throw Exception("Failed to load data");
      }
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
                ? buildGameContent()
                : buildLoadingOrError(),
      ),
    );
  }

  Widget buildGameContent() {
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
                style: textStyle(size: 12, bold: true),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(game!.name, style: textStyle(size: 22, bold: true)),
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
            trimLines: 8,
            trimMode: TrimMode.Line,
            trimCollapsedText: "  Read more",
            trimExpandedText: "  Show less",
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white),
            moreStyle: purpleLinkStyle(),
            lessStyle: purpleLinkStyle(),
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
                      game!.platforms!.join(', '),
                      style: TextStyle(color: Colors.green),
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
                      border: Border.all(color: Colors.green),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      intCheck(game?.metascore.toString()),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 20),
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
                      formatDate(game!.released),
                      style: const TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildLoadingOrError() => Center(
    child:
        errorMessage.isNotEmpty
            ? Text(errorMessage, style: const TextStyle(color: Colors.red))
            : const CircularProgressIndicator(),
  );

  String formatDate(String rawDate) =>
      DateFormat('MMM d, y').format(DateTime.parse(rawDate));

  TextStyle textStyle({double size = 14, bool bold = false}) => TextStyle(
    color: Colors.white,
    fontSize: size,
    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
  );

  TextStyle labelStyle() {
    return TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
  }

  TextStyle purpleLinkStyle() => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(255, 206, 169, 255),
  );

  String intCheck(String? s) {
    return (s ?? "N/A");
  }
}
