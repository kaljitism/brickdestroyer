import 'package:flutter/material.dart';

class Brick extends StatelessWidget {
  const Brick({
    super.key,
    required this.brickX,
    required this.brickY,
    required this.brickBroken,
    required this.brickHeight,
    required this.brickWidth,
  });

  final double brickX;
  final double brickY;
  final bool brickBroken;
  final double brickHeight;
  final double brickWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment(brickX, brickY),
      child: brickBroken
          ? Container()
          : Container(
              height: MediaQuery.of(context).size.height * brickHeight / 2,
              width: MediaQuery.of(context).size.height * brickWidth / 2,
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
    );
  }
}
