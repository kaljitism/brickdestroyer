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

  double playerX = -0.25;
  double playerWidth = 0.5;

  double playerDY = 0.04;

  bool hasGameStarted = false;

  double movingWeight = 0.01;

  void startGame() {
    Timer.periodic(const Duration(milliseconds: 10), (timer) {
      setState(() {
        hasGameStarted = true;
        ballY += 0.01;
        if (ballY > 0.885) {
          timer.cancel();
        }
      });
    });
  }

  void moveLeft() {
    if (hasGameStarted) {
      setState(() {
        playerX > -1 ? playerX -= playerDY : playerX;
      });
    }
  }

  void moveRight() {
    if (hasGameStarted) {
      setState(() {
        playerX + playerWidth < 1 ? playerX += playerDY : playerX;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx > 0) moveRight();
        if (details.delta.dx < 0) moveLeft();
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
                Player(
                  playerX: playerX,
                  playerWidth: playerWidth,
                ),
                Container(
                  alignment: Alignment(playerX, 0.9),
                  child: Container(
                    height: 15,
                    width: 10,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
