import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  const Player({
    super.key,
    required this.playerX,
    required this.playerWidth,
  });

  final double playerX;
  final double playerWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment:
          Alignment((2 * playerX + playerWidth) / (2 - playerWidth), 0.9),
      child: Container(
        width: MediaQuery.of(context).size.width * playerWidth / 2,
        height: 10,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.deepPurple,
        ),
      ),
    );
  }
}
