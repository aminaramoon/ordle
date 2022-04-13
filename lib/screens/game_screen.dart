import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/widgets/keyboard.dart';
import 'package:wordle/widgets/wordpad.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.appbarBackgroundColor,
        title: const Text("Ordle"),
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          tooltip: 'user',
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat),
            tooltip: 'reset',
            onPressed: () => context.read<KeyboardProvider>().reset(),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'add word',
            onPressed: () => {},
          ),
        ],
      ),
      drawer: const Drawer(
        child: Text("hello"),
        backgroundColor: Colors.amber,
        elevation: 10,
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(top: 5),
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
