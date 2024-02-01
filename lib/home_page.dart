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

enum Direction { up, down }

class _HomePageState extends State<HomePage> {
  // Ball Position Variables
  double ballX = 0;
  double ballY = 0;
  Direction direction = Direction.down;

  // Player Position Variables
  double playerX = -0.25;
  double playerWidth = 0.5;

  double playerDY = 0.04;

  // Game Settings
  bool hasGameStarted = false;

  // start the game
  void startGame() {
    moveBall();
    updateDirection();

    hasGameStarted = true;
    Timer.periodic(
      const Duration(milliseconds: 10),
      (timer) {
        moveBall();
      },
    );
  }

  // Move the Ball
  void moveBall() {
    setState(() {
      if (direction == Direction.down) {
        ballY += 0.01;
      } else if (direction == Direction.down) {
        ballY -= 0.01;
      }
    });
  }

  // Update the Ball Direction
  void updateDirection() {
    setState(() {
      if (ballY > 0.9) {
        direction = Direction.up;
      } else if (ballY < -0.9) {
        direction = Direction.down;
      }
    });
  }

  // move player left
  void moveLeft() {
    if (hasGameStarted) {
      setState(() {
        playerX > -1 ? playerX -= playerDY : playerX;
      });
    }
  }

  // move player right
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
