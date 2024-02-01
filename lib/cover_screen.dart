import 'package:flutter/material.dart';

class CoverScreen extends StatelessWidget {
  const CoverScreen({super.key, required this.hasGameStarted});

  final bool hasGameStarted;

  @override
  Widget build(BuildContext context) {
    return hasGameStarted
        ? Container()
        : Container(
            alignment: const Alignment(0, -0.2),
            child: const Text('Tap to Play!'),
          );
  }
}
