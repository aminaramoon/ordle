import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/states/keyboard_provider.dart';

class LetterPad extends StatelessWidget {
  LetterPad({Key? key, int code = 0}) : super(key: key) {
    if (code == 0) {
      letter = " ";
      backgroundColor = Colors.grey;
    } else {
      letter = String.fromCharCode(code & 0xFF);
      backgroundColor = (code & 0x300 == 0)
          ? AppTheme.panelColor
          : (code & 0x100 != 0)
              ? AppTheme.correctLetterColor
              : AppTheme.misplacedLetterColor;
    }
  }

  late final String letter;
  late final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
      child: Container(
        constraints: const BoxConstraints.expand(height: 55.0, width: 55.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(1),
            border: Border.all(color: Colors.black, width: 2.5)),
        child: FittedBox(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.letterFontColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class WordPad extends StatelessWidget {
  WordPad({Key? key, String keyword = ""}) : super(key: key) {
    wordState = (keyword + "     ").substring(0, 5);
  }

  late final String wordState;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: wordState.characters
            .map<LetterPad>((element) => LetterPad(
                  code: element.codeUnitAt(0),
                ))
            .toList());
  }
}

class WordPads extends StatelessWidget {
  const WordPads({Key? key, required this.numberOfGuesses}) : super(key: key);

  final int numberOfGuesses;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i != numberOfGuesses; ++i)
            Selector<KeyboardProvider, String>(
                selector: (_, provider) => provider.guessWords[i],
                builder: (context, word, child) {
                  return WordPad(keyword: word);
                })
        ],
      ),
    );
  }
}
