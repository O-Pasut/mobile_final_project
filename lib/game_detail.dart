import 'package:flutter/material.dart';

class GameDetailDialog extends StatelessWidget {
  const GameDetailDialog({super.key});

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
            const Text(
              'Custom Dialog',
              style: TextStyle(fontSize: 22, color: Colors.white),
            ),
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
