import 'package:flutter/material.dart';
import 'package:mobile_final_project/main_template.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    return const MainTemplate(icon: Icons.star, label: "Favourites");
  }
}
