import 'package:flutter/material.dart';
import 'package:mobile_final_project/navbar/navbar_control.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NavbarControl());
  }
}
