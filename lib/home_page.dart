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

enum Direction { up, down, left, right }

class _HomePageState extends State<HomePage> {
  // Ball Variables
  double ballX = 0;
  double ballY = 0;
  double ballXIncrements = 0.01;
  double ballYIncrements = 0.01;
  Direction ballYDirection = Direction.down;
  Direction ballXDirection = Direction.left;

  // Player Position Variables
  double playerX = -0.25;
  double playerY = 0.9;
  double playerWidth = 0.5;

  double playerDY = 0.04;

  // Brick Variables
  static double firstBrickX = 0;
  static double firstBrickY = -0.8;

  static double brickHeight = 0.02;
  static double brickWidth = 0.2;

  static double brickXPadding = 0.4;
  static double brickYPadding = 0.05;

  Color brickColor = Colors.deepPurple.shade900;

  bool brickBroken = false;

  static List bricks = [
    // First Row
    [firstBrickX, firstBrickY, false],
    [firstBrickX + brickWidth + brickXPadding, firstBrickY, false],
    [firstBrickX - brickWidth - brickXPadding, firstBrickY, false],

    // Second Row
    [firstBrickX, firstBrickY - brickHeight - brickYPadding, false],
    [
      firstBrickX + brickWidth + brickXPadding,
      firstBrickY - brickHeight - brickYPadding,
      false
    ],
    [
      firstBrickX - brickWidth - brickXPadding,
      firstBrickY - brickHeight - brickYPadding,
      false
    ],

    // Third Row
    [firstBrickX, firstBrickY - 2 * (brickHeight - brickYPadding), false],
    [
      firstBrickX + brickWidth + brickXPadding,
      firstBrickY - 2 * (brickHeight - brickYPadding),
      false
    ],
    [
      firstBrickX - brickWidth - brickXPadding,
      firstBrickY - 2 * (brickHeight - brickYPadding),
      false
    ],
  ];

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
      // log('$ballX, $ballY');
      // Move Horizontally
      if (ballXDirection == Direction.left) {
        ballX -= ballXIncrements;
      }
      if (ballXDirection == Direction.right) {
        ballX += ballXIncrements;
      }

      // Move Vertically
      if (ballYDirection == Direction.down) {
        ballY += ballYIncrements;
      }
      if (ballYDirection == Direction.up) {
        ballY -= ballYIncrements;
      }
    });
  }

  // Update the Ball Direction
  void updateDirection() {
    setState(() {
      // ball goes up when it hits the player
      if (ballY >= 0.9 && ballX >= playerX && ballX <= playerY + playerWidth) {
        ballYDirection = Direction.up;
      }
      // ball goes down when it hits the top
      if (ballY <= -1) {
        ballYDirection = Direction.down;
      }

      // update direction horizontally
      if (ballX <= -1) {
        ballXDirection = Direction.right;
      }
      if (ballX >= 1) {
        ballXDirection = Direction.left;
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
    if (ballX >= bricks[0][0] &&
        ballX <= bricks[0][0] + brickWidth &&
        ballY <= bricks[0][1] + brickHeight &&
        brickBroken == false) {
      setState(() {
        brickBroken = true;
        ballYDirection = Direction.down;
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
            child: Builder(builder: (context) {
              return Stack(
                children: [
                  CoverScreen(
                    hasGameStarted: hasGameStarted,
                  ),
                  GameOverScreen(
                    isGameOver: isGameOver,
                  ),
                  Brick(
                    brickX: bricks[0][0],
                    brickY: bricks[0][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[1][0],
                    brickY: bricks[1][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[2][0],
                    brickY: bricks[2][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[3][0],
                    brickY: bricks[3][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[4][0],
                    brickY: bricks[4][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[5][0],
                    brickY: bricks[5][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[6][0],
                    brickY: bricks[6][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[7][0],
                    brickY: bricks[7][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[8][0],
                    brickY: bricks[8][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: brickBroken,
                    color: brickColor,
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
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
