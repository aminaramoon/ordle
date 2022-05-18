import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/states/keyboard_provider.dart';

class LetterCard extends StatelessWidget {
  const LetterCard(
      {Key? key, required this.letter, required LetterStatus status})
      : backgroundColor = status == LetterStatus.correct
            ? AppTheme.correctLetterColor
            : status == LetterStatus.misplaced
                ? AppTheme.misplacedLetterColor
                : status == LetterStatus.pressed
                    ? AppTheme.usedLetterColor
                    : AppTheme.keypadColor,
        radius = status != LetterStatus.intact ? 25.0 : 10.0,
        super(key: key);

  final String letter;
  final Color backgroundColor;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.fastOutSlowIn,
        constraints: const BoxConstraints.expand(height: 55.0, width: 55.0),
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: AppTheme.panelBorderColor, width: 2.5)),
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

class WordCard extends StatelessWidget {
  const WordCard({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i != 5; ++i)
          Selector<KeyboardProvider, LetterState>(
            selector: (_, provider) => provider.guessWords[index].letters[i],
            builder: (context, state, _) {
              return LetterCard(letter: state.letter, status: state.status);
            },
          )
      ],
    );
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
        children: List.generate(6, (index) => WordCard(index: index)),
      ),
    );
  }
}
