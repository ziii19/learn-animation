import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:simple_game/simple_game.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  LearnFlameGame? _game;

  @override
  void initState() {
    super.initState();
    _game = LearnFlameGame();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GameWidget(game: _game!),
    );
  }
}
