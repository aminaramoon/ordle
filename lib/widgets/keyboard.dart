import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/states/keyboard_provider.dart';

class CharKeyPad extends StatelessWidget {
  const CharKeyPad({Key? key, required this.code})
      : backgroundColor = code & 0x780 == 0
            ? AppTheme.keypadColor
            : (code & 0x100 != 0)
                ? AppTheme.correctLetterColor
                : (code & 0x200 != 0)
                    ? AppTheme.misplacedLetterColor
                    : AppTheme.usedLetterColor,
        super(key: key);

  final int code;
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
              String.fromCharCode(code & 0x7f),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.keyFontColor,
              ),
            ),
          ),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.read<KeyboardProvider>().appendLetter(code & 0x7f);
          },
        ),
      ),
    );
  }
}

class ActionKeyPad extends StatelessWidget {
  const ActionKeyPad({Key? key, required this.icon, this.callback})
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

class KeyPadRow extends StatelessWidget {
  const KeyPadRow({Key? key, required this.keys}) : super(key: key);

  final String keys;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: keys.characters
          .map<CharKeyPad>((e) => CharKeyPad(code: e.codeUnitAt(0)))
          .toList(),
    );
  }
}

class Keyboard extends StatelessWidget {
  const Keyboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(3.0, 5.0, 3.0, 5.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Selector<KeyboardProvider, String>(
                selector: (_, provider) => provider.coloredFirstRow,
                builder: (context, keypads, child) {
                  return KeyPadRow(keys: keypads);
                }),
            Selector<KeyboardProvider, String>(
                selector: (_, provider) => provider.coloredSecondRow,
                builder: (context, keypads, child) {
                  return KeyPadRow(keys: keypads);
                }),
            Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ActionKeyPad(
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
                  Selector<KeyboardProvider, String>(
                      selector: (_, provider) => provider.coloredThirdRow,
                      builder: (context, keypads, child) {
                        return KeyPadRow(keys: keypads);
                      }),
                  ActionKeyPad(
                    icon: Icons.backspace,
                    callback: () =>
                        context.read<KeyboardProvider>().removeLetter(),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
