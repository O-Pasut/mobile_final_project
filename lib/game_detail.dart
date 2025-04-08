import 'package:flutter/material.dart';

class GameDetailDialog extends StatelessWidget {
  final String slug;
  final String name;
  final String released;
  final String imageBackground;
  final double rating;
  final int ratingTop;
  const GameDetailDialog({
    super.key,
    required this.slug,
    required this.name,
    required this.released,
    required this.imageBackground,
    required this.rating,
    required this.ratingTop,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      backgroundColor: Colors.white,
      elevation: 16,
      child: Container(
        padding: const EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade200, Colors.blue.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(name, style: TextStyle(fontSize: 22, color: Colors.white)),
            const SizedBox(height: 10),
            const Text(
              'This is a decorated dialog box.',
              style: TextStyle(color: Colors.white70),
            ),
            const Spacer(),
            ElevatedButton(
              child: const Text('Close'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}
