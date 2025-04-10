import 'dart:ui';
import 'package:flutter/material.dart';

class MainTemplate extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Widget? body;

  const MainTemplate({super.key, this.icon, this.label, this.body});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Positioned.fill(child: Image.asset("assets/bg.jpg", fit: BoxFit.cover)),
        _blurLayer(size),
        _profile(size),
        _mainLayer(size),
      ],
    );
  }

  Widget _blurLayer(Size s) => Positioned(
    bottom: 0,
    child: ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(55)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
        child: Container(
          width: s.width,
          height: s.height,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 105, 70, 172).withOpacity(0.1),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(55)),
          ),
        ),
      ),
    ),
  );

  Widget _profile(Size s) => Positioned(
    top: s.height * 0.07,
    left: s.width * 0.07,
    child: Row(
      children: [
        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
            gradient: const LinearGradient(
              colors: [Color(0xFF6A47AC), Color(0xFFCC4B58)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(15),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: const Icon(Icons.person, color: Colors.white),
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Username',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Email',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ],
    ),
  );

  Widget _mainLayer(Size s) => Positioned(
    bottom: 0,
    child: ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: s.width,
          height: s.height * 0.86,
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(45)),
            border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              if (icon != null && label != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white),
                    const SizedBox(width: 20),
                    Text(
                      label!,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 5),
              Expanded(child: body ?? const SizedBox.shrink()),
            ],
          ),
        ),
      ),
    ),
  );
}
