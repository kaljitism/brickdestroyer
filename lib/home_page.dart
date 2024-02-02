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
  static double firstBrickX = -1 + wallGap;
  static double firstBrickY = -0.9;

  static double brickHeight = 0.05;
  static double brickWidth = 0.25;

  static double brickXPadding = 0.4;

  static int numberOfBricksInRow = 3;
  static double wallGap = 0.5 *
      (2 -
          numberOfBricksInRow * brickWidth -
          (numberOfBricksInRow - 1) * brickXPadding);

  Color brickColor = Colors.deepPurple.shade900;

  static List bricks = [
    // First Row
    [firstBrickX + 0 * (brickWidth + brickXPadding), firstBrickY, false],
    [firstBrickX + 1 * (brickWidth + brickXPadding), firstBrickY, false],
    [firstBrickX + 2 * (brickWidth + brickXPadding), firstBrickY, false],
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
    for (var i = 0; i < bricks.length; i++) {
      if (ballX >= bricks[i][0] &&
          ballX <= bricks[i][0] + brickWidth &&
          ballY <= bricks[i][1] + brickHeight &&
          bricks[i][2] == false) {
        setState(() {
          bricks[i][2] = true;

          // As brick is broken, update direction of ball
          // based on which  side of  the brick it hit to do
          // this, calculate the distance of the ball from each
          // if the 4 sides. The smallest distance is the side the
          // ball has it

          double leftSideDist = (bricks[i][0] - ballX).abs();
          double rightSideDist = (bricks[i][0] + brickWidth - ballX).abs();
          double topSideDist = (bricks[i][1] - ballY).abs();
          double bottomSideDist = (bricks[i][1] + brickHeight - ballY).abs();

          String min = findMin(
            left: leftSideDist,
            right: rightSideDist,
            top: topSideDist,
            bottom: bottomSideDist,
          );

          switch (min) {
            case 'left':
              ballXDirection = Direction.left;
              break;
            case 'right':
              ballXDirection = Direction.right;
              break;
            case 'up':
              ballYDirection = Direction.up;
              break;
            case 'down':
              ballYDirection = Direction.down;
              break;
            default:
          }

          // if ball hits bottom side of brick then
          ballYDirection = Direction.down;

          // if ball hits top side of the brick then
          ballYDirection = Direction.up;

          // if the ball hits right side of the brick then
          ballYDirection = Direction.left;

          // if the ball hits left side of the brick then
          ballYDirection = Direction.right;
        });
      }
    }
  }

  // find minimum distance of ball from all sides of brick
  String findMin(
      {required double left,
      required double right,
      required double top,
      required double bottom}) {
    List<double> distances = [left, right, top, bottom];

    double currentMin = left;
    for (int i = 0; i < distances.length; i++) {
      if (distances[i] < currentMin) {
        currentMin = distances[i];
      }
    }

    if ((currentMin - left).abs() < 0.01) {
      return 'left';
    } else if ((currentMin - right).abs() < 0.01) {
      return 'right';
    } else if ((currentMin - top).abs() < 0.01) {
      return 'top';
    } else if ((currentMin - bottom).abs() < 0.01) {
      return 'bottom';
    }
    return '';
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
                    brickBroken: bricks[0][2],
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[1][0],
                    brickY: bricks[1][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: bricks[1][2],
                    color: brickColor,
                  ),
                  Brick(
                    brickX: bricks[2][0],
                    brickY: bricks[2][1],
                    brickHeight: brickHeight,
                    brickWidth: brickWidth,
                    brickBroken: bricks[2][2],
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
