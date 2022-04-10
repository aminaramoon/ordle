import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/widgets/keyboard.dart';
import 'package:wordle/widgets/wordpad.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ordle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat),
            tooltip: 'restart',
            onPressed: () => context.read<KeyboardProvider>().reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const WordPads(numberOfGuesses: 6),
            Expanded(child: Container()),
            const Keyboard(),
          ],
        ),
      ),
    );
  }
}

