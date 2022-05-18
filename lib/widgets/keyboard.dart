import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/services/locale.dart';

class LetterKey extends StatelessWidget {
  const LetterKey(
      {Key? key, required this.letter, required LetterStatus status})
      : backgroundColor = status == LetterStatus.correct
            ? AppTheme.correctLetterColor
            : status == LetterStatus.misplaced
                ? AppTheme.misplacedLetterColor
                : status == LetterStatus.pressed
                    ? AppTheme.usedLetterColor
                    : AppTheme.keypadColor,
        super(key: key);

  final String letter;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 3.0, 3.0, 3.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(height: 40.0, width: 30.0),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder?>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
            ),
            backgroundColor: MaterialStateProperty.all<Color?>(backgroundColor),
            padding:
                MaterialStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
          ),
          child: Center(
            child: Text(
              letter,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.keyFontColor,
              ),
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.read<KeyboardProvider>().pushLetter(letter);
          },
        ),
      ),
    );
  }
}

class ActionKey extends StatelessWidget {
  const ActionKey({Key? key, required this.icon, this.callback})
      : super(key: key);

  final IconData icon;
  final Color iconColor = AppTheme.keyFontColor;
  final VoidCallback? callback;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints.expand(height: 40.0, width: 45.0),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<OutlinedBorder?>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0))),
            backgroundColor:
                MaterialStateProperty.all<Color?>(AppTheme.keypadColor),
            padding:
                MaterialStateProperty.all<EdgeInsets?>(const EdgeInsets.all(0)),
          ),
          child: Center(
            child: Icon(icon, color: iconColor),
          ),
          onPressed: () {
            HapticFeedback.heavyImpact();
            if (callback != null) callback!();
          },
        ),
      ),
    );
  }
}

class KeyRow extends StatelessWidget {
  const KeyRow({Key? key, required this.firstIndex, required this.secondIndex})
      : super(key: key);

  final int firstIndex;
  final int secondIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = firstIndex; i != secondIndex; ++i)
          Selector<KeyboardProvider, LetterState>(
            selector: (_, provider) => provider.alphabetKeys[i],
            builder: (context, state, _) {
              return LetterKey(letter: state.letter, status: state.status);
            },
          )
      ],
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key, required this.locale}) : super(key: key);

  final LanguageLocale locale;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            KeyRow(
              firstIndex: 0,
              secondIndex: locale.secondRowIndex,
            ),
            KeyRow(
              firstIndex: locale.secondRowIndex,
              secondIndex: locale.thirdRowIndex,
            ),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionKey(
                    icon: Icons.keyboard_return_rounded,
                    callback: () async {
                      var provider = context.read<KeyboardProvider>();
                      var result = await provider.submitAnswer();
                      if (result == SubmissionResult.correct) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text(provider.winningMessage),
                                  content: Text(
                                      "word was ${provider.guessWord.toLowerCase()}"),
                                  backgroundColor: Colors.green,
                                  actions: [
                                    TextButton(
                                      child: const Text("new game"),
                                      onPressed: () {
                                        provider.newGame(null);
                                        Navigator.of(context,
                                                rootNavigator: false)
                                            .pop();
                                      },
                                    ),
                                  ],
                                ));
                      } else if (result == SubmissionResult.invalid) {
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(SnackBar(
                            content: Text(
                                "not a word ${provider.guessWord.toLowerCase()}"),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 1),
                            backgroundColor:
                                const Color.fromARGB(255, 19, 20, 20),
                          ));
                      } else if (result == SubmissionResult.done) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("done"),
                                  content: Text(
                                      "word is ${provider.keyword.toLowerCase()}"),
                                  actions: [
                                    TextButton(
                                      child: const Text("new game"),
                                      onPressed: () {
                                        provider.newGame(null);
                                        Navigator.of(context,
                                                rootNavigator: false)
                                            .pop();
                                      },
                                    ),
                                  ],
                                ));
                      } else if (result == SubmissionResult.notMatch) {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: const Text("done"),
                                  content: Text(
                                      "word is ${provider.hardModeMismatchMsg}"),
                                  actions: [
                                    TextButton(
                                      child: const Text("continue"),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: false)
                                            .pop();
                                      },
                                    ),
                                  ],
                                ));
                      }
                    },
                  ),
                  KeyRow(
                    firstIndex: locale.thirdRowIndex,
                    secondIndex: locale.alphabet.length,
                  ),
                  ActionKey(
                    icon: Icons.backspace,
                    callback: () =>
                        context.read<KeyboardProvider>().removeLetter(),
                  ),
                ]),
            Container(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                height: 20,
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                    ),
                  ),
                  child: const Icon(Icons.arrow_drop_up),
                  onPressed: () => {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
