import 'dart:async';

import 'package:brickdestroyer/ball.dart';
import 'package:brickdestroyer/cover_screen.dart';
import 'package:brickdestroyer/player.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double ballX = 0;
  double ballY = 0;

  double playerX = 0;
  double playerWidth = 0.5;

  bool hasGameStarted = false;

  double movingWeight = 0.01;

  void startGame() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        hasGameStarted = true;
        ballY -= 0.01;
        if (ballY < -1) {
          timer.cancel();
        }
      });
    });
  }

  void moveLeft(double dx) {
    setState(() {
      playerX += dx * movingWeight;
    });
  }

  void moveRight(double dx) {
    setState(() {
      playerX -= dx * movingWeight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        // Swiping in right direction.
        if (details.delta.dx > 0) moveRight(details.delta.dx);
        // Swiping in left direction.
        if (details.delta.dx < 0) moveLeft(details.delta.dx);
      },
      child: GestureDetector(
        onTap: startGame,
        child: Scaffold(
          backgroundColor: Colors.deepPurple.shade100,
          body: Center(
            child: Stack(
              children: [
                CoverScreen(
                  hasGameStarted: hasGameStarted,
                ),
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                ),
                Player(playerX: playerX, playerWidth: playerWidth)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
