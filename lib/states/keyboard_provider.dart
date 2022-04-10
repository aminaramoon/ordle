import 'package:flutter/material.dart';
import 'package:wordle/services/dictionary.dart';
import 'package:wordle/services/locale.dart';

enum SubmissionResult { invalid, incorrect, correct, incomplete, done }

class KeyboardProvider with ChangeNotifier {

  final LanguageLocale _locale = const LanguageLocale.en();

  String _keyword = "NATAL";

  final int _numberOfLetters = 5;
  int get numberOfLetters => _numberOfLetters;

  final int _numberOfGuesses = 6;
  int get numberOfGuesses => _numberOfGuesses;

  int _activeRow = 0;
  int get activeRow => _activeRow;

  List<String> _guessWords = List<String>.filled(6, "", growable: false);
  List<String> get guessWords => _guessWords;

  String _guessWord = "";
  String get guessWord => _guessWord;

  bool _isWon = false;

  bool _isWord = false;
  bool get isWord => _isWord;

  String _coloredFirstRow = const LanguageLocale.en().firstRow;
  String get coloredFirstRow => _coloredFirstRow;

  String _coloredSecondRow = const LanguageLocale.en().secondRow;
  String get coloredSecondRow => _coloredSecondRow;

  String _coloredThirdRow = const LanguageLocale.en().thirdRow;
  String get coloredThirdRow => _coloredThirdRow;

  void newGame() async {
    _keyword = await Dictionary().chooseWord();
    reset();
  }

  void reset() {
    _coloredFirstRow = _locale.firstRow;
    _coloredSecondRow = _locale.secondRow;
    _coloredThirdRow = _locale.thirdRow;
    _activeRow = 0;
    _isWon = false;
    _guessWord = "";
    _guessWords = List<String>.filled(numberOfGuesses, "", growable: false);
    notifyListeners();
  }

  void updateKeyboard(String comparedKeyword) {
    for (final element in comparedKeyword.characters) {
      int eCode = element.codeUnitAt(0);
      int eCharCode = eCode & 0x7F;
      for (int i = 0; i != _coloredFirstRow.characters.length; ++i) {
        final char = _coloredFirstRow.characters.elementAt(i);
        int code = char.codeUnitAt(0);
        if ((0x7F & code) == eCharCode) {
          code = code | eCode | 0x80;
          _coloredFirstRow = _coloredFirstRow.replaceFirst(
              RegExp(char), String.fromCharCode(code), i);
          break;
        }
      }

      for (int i = 0; i != _coloredSecondRow.characters.length; ++i) {
        final char = _coloredSecondRow.characters.elementAt(i);
        int code = char.codeUnitAt(0);
        if ((0x7F & code) == eCharCode) {
          code = code | eCode | 0x80;
          _coloredSecondRow = _coloredSecondRow.replaceFirst(
              RegExp(char), String.fromCharCode(code), i);
          break;
        }
      }

      for (int i = 0; i != _coloredThirdRow.characters.length; ++i) {
        final char = _coloredThirdRow.characters.elementAt(i);
        int code = char.codeUnitAt(0);
        if ((0x7F & code) == eCharCode) {
          code = code | eCode | 0x80;
          _coloredThirdRow = _coloredThirdRow.replaceFirst(
              RegExp(char), String.fromCharCode(code), i);
          break;
        }
      }
    }
  }

  Future<SubmissionResult> submitAnswer() async {
    if (_guessWord.length == numberOfLetters && _activeRow < numberOfGuesses) {
      _isWord = await Dictionary().isWord(_guessWord);
      if (_isWord) {
        _compareAnswers();
        _guessWords[activeRow] = _guessWord;
        _activeRow += 1;
        _guessWord = "";
        notifyListeners();
        return _isWon
            ? SubmissionResult.correct
            : _activeRow == numberOfGuesses
                ? SubmissionResult.done
                : SubmissionResult.incorrect;
      } else {
        return SubmissionResult.invalid;
      }
    }
    return SubmissionResult.incomplete;
  }

  void appendLetter(int c) {
    if (_guessWord.length < numberOfLetters && _activeRow < numberOfGuesses) {
      _guessWord += String.fromCharCode(c);
      _guessWords[activeRow] = _guessWord;
      notifyListeners();
    }
  }

  void removeLetter() {
    if (_guessWord.isNotEmpty && _activeRow < numberOfGuesses) {
      _guessWord = _guessWord.characters.skipLast(1).toString();
      _guessWords[activeRow] = _guessWord;
      notifyListeners();
    }
  }

  void _compareAnswers() {
    String comparedWord = "";
    String keywordCpy = _keyword;
    int correctLetters = 0;

    for (int i = 0; i != numberOfLetters; i++) {
      var char = _guessWord.characters.elementAt(i);
      if (keywordCpy.contains(char) &&
          char == keywordCpy.characters.elementAt(i)) {
        comparedWord += String.fromCharCode(
            _guessWord.characters.elementAt(i).codeUnitAt(0) | 0x100);
        keywordCpy = keywordCpy.replaceFirst(RegExp(char), '0', i);
        correctLetters += 1;
      } else if (keywordCpy.contains(char)) {
        comparedWord += String.fromCharCode(
            _guessWord.characters.elementAt(i).codeUnitAt(0) | 0x200);
        keywordCpy = keywordCpy.replaceFirst(RegExp(char), '0');
      } else {
        comparedWord += _guessWord.characters.elementAt(i);
      }
    }
    _isWon = correctLetters == numberOfLetters;
    _guessWord = comparedWord;
    updateKeyboard(comparedWord);
  }
}
