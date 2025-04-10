import 'package:flutter/material.dart';
import 'package:mobile_final_project/homepage/game_list.dart';
import 'package:mobile_final_project/homepage/image_slider.dart';
import 'package:mobile_final_project/main_template.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainTemplate(body: _homepageBody());
  }

  Widget _homepageBody() {
    return Container(
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ImageSlider(),
          SizedBox(height: 20),
          const Text(
            "Trending Games",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          GameList(startIndex: 0),
          SizedBox(height: 20),
          const Text(
            "Recommend",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          SizedBox(height: 10),
          GameList(startIndex: 3),
        ],
      ),
    );
  }
}
