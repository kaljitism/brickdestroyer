import 'package:flutter/material.dart';

class MyBall extends StatelessWidget {
  const MyBall({
    super.key,
    required this.ballX,
    required this.ballY,
  });

  final double ballX;
  final double ballY;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(ballX, ballY),
      child: Container(
        height: 15,
        width: 15,
        decoration: const BoxDecoration(
          color: Colors.deepPurple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
