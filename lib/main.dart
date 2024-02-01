import 'package:brickdestroyer/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const BrickDestroyer());
}

class BrickDestroyer extends StatelessWidget {
  const BrickDestroyer({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Bricks Destroyer',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
