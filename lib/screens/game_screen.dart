import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/services/locale.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/states/oauth_provider.dart';
import 'package:wordle/widgets/wordpad.dart';
import 'package:wordle/widgets/keyboard.dart';

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
        actions: [
          TextButton(
            child: Text(
              "hard",
              style: TextStyle(
                  color: context.watch<KeyboardProvider>().hardMode
                      ? AppTheme.appBarActiveFontColor
                      : AppTheme.appBarFontColor),
            ),
            onPressed: () => context.read<KeyboardProvider>().toggleHardMode(),
          ),
          TextButton(
            child: const Text(
              "redo",
              style: TextStyle(color: AppTheme.appBarFontColor),
            ),
            onPressed: () => context.read<KeyboardProvider>().reset(),
          ),
          TextButton(
            child: const Text(
              "skip",
              style: TextStyle(color: AppTheme.appBarFontColor),
            ),
            onPressed: () => context.read<KeyboardProvider>().newGame(null),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const WordPads(numberOfGuesses: 6),
            Expanded(child: Container()),
            Visibility(
              child: const Keyboard(locale: LanguageLocale.en()),
              visible: context.watch<KeyboardProvider>().visible,
            )
          ],
        ),
      ),
    );
  }
}
