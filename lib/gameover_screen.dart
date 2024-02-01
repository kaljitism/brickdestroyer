import 'package:flutter/material.dart';

class GameOverScreen extends StatelessWidget {
  const GameOverScreen({
    super.key,
    required this.isGameOver,
  });

  final bool isGameOver;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: const Alignment(0, -0.3),
      child: isGameOver
          ? const Text(
              'G A M E  O V E R',
              style: TextStyle(fontWeight: FontWeight.bold),
            )
          : Container(),
    );
  }
}
