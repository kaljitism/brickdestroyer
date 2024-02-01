import 'dart:async';

import 'package:brickdestroyer/ball.dart';
import 'package:brickdestroyer/brick.dart';
import 'package:brickdestroyer/cover_screen.dart';
import 'package:brickdestroyer/gameover_screen.dart';
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
  double ballXIncrements = 0;
  double ballYIncrements = 0;
  Direction direction = Direction.down;

  // Player Position Variables
  double playerX = -0.25;
  double playerY = 0.9;
  double playerWidth = 0.5;

  double playerDY = 0.04;

  // Brick Variables
  double brickX = 0;
  double brickY = -0.8;

  double brickHeight = 0.02;
  double brickWidth = 0.2;

  bool brickBroken = false;

  // Game Settings
  bool hasGameStarted = false;
  bool isGameOver = false;

  // start the game
  void startGame() {
    setState(() {
      hasGameStarted = true;
      Timer.periodic(
        const Duration(milliseconds: 10),
        (timer) {
          moveBall();
          updateDirection();
          if (isPlayerDead()) {
            timer.cancel();
            isGameOver = true;
          }
          checkForBrokenBricks();
        },
      );
    });
  }

  // Move the Ball
  void moveBall() {
    setState(() {
      if (direction == Direction.down) {
        ballY += 0.01;
      } else if (direction == Direction.up) {
        ballY -= 0.01;
      }
    });
  }

  // Update the Ball Direction
  void updateDirection() {
    setState(() {
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerY + playerWidth) {
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

  // Check if the brick is broken
  void checkForBrokenBricks() {
    if (ballX >= brickX &&
        ballX <= brickX + brickWidth &&
        ballY <= brickY + brickHeight &&
        brickBroken == false) {
      setState(() {
        brickBroken = true;
        direction = Direction.down;
      });
    }
  }

  // Check's if game is over or not?
  bool isPlayerDead() {
    if (ballY > 1) {
      return true;
    }
    return false;
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
                GameOverScreen(
                  isGameOver: isGameOver,
                ),
                Brick(
                  brickX: brickX,
                  brickY: brickY,
                  brickHeight: brickHeight,
                  brickWidth: brickWidth,
                  brickBroken: brickBroken,
                ),
                MyBall(
                  ballX: ballX,
                  ballY: ballY,
                ),
                Player(
                  playerX: playerX,
                  playerY: playerY,
                  playerWidth: playerWidth,
                ),
                Container(
                  alignment: Alignment(brickX, brickY),
                  child: Container(
                    color: Colors.blue,
                    width: 5,
                    height: 10,
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
