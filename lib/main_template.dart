import 'dart:ui';
import 'package:flutter/material.dart';

class MainTemplate extends StatelessWidget {
  final IconData? icon;
  final String? label;
  final Widget? body;

  const MainTemplate({super.key, this.icon, this.label, this.body});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        _buildBackgroundImage(),
        _buildBlurLayer(
          width: screenSize.width,
          height: screenSize.height,
          blur: 25,
          radius: 55,
          opacity: 0.1,
        ),
        _buildProfile(screenSize.width, screenSize.height),
        _buildMainLayer(
          screenSize.width,
          screenSize.height,
          icon: icon,
          label: label,
          body: body,
        ),
      ],
    );
  }

  Widget _buildBackgroundImage() =>
      Positioned.fill(child: Image.asset("assets/bg.jpg", fit: BoxFit.cover));

  Widget _buildBlurLayer({
    required double width,
    required double height,
    required double blur,
    required double radius,
    required double opacity,
  }) {
    return Positioned(
      bottom: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color.fromARGB(
                255,
                105,
                70,
                172,
              ).withOpacity(opacity),
              borderRadius: BorderRadius.vertical(top: Radius.circular(radius)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfile(double width, double height) {
    return Positioned(
      top: height * 0.07,
      left: width * 0.07,
      child: Row(
        children: [
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
              gradient: const LinearGradient(
                colors: [Color(0xFF6A47AC), Color(0xFFCC4B58)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Icon(Icons.person, color: Colors.white),
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
  }

  Widget _buildHeader(IconData? icon, String? label) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(width: 20),
        Text(
          label!,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildMainLayer(
    double width,
    double height, {
    IconData? icon,
    String? label,
    Widget? body,
  }) {
    return Positioned(
      bottom: 0,
      child: ClipRRect(
        borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: width,
            height: height * 0.86,
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(45)),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                if (icon != null && label != null) _buildHeader(icon, label),
                const SizedBox(height: 5),
                Expanded(child: body ?? SizedBox.shrink()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
