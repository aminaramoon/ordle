import 'package:flutter/material.dart';
import 'package:wordle/services/dictionary.dart';
import 'package:wordle/services/locale.dart';

enum SubmissionResult {
  invalid,
  incorrect,
  correct,
  incomplete,
  done,
  notMatch,
}

class WordRowState {
  WordRowState({required this.word, required this.state}) : radius = 8;

  WordRowState.empty()
      : word = "",
        state = SubmissionResult.invalid,
        radius = 8;

  WordRowState.keyword(String keyword)
      : word = keyword,
        state = SubmissionResult.invalid,
        radius = 8;

  WordRowState.fromGuess(String keyword)
      : word = keyword,
        state = SubmissionResult.incomplete,
        radius = 20;

  final String word;
  final SubmissionResult state;
  final double radius;
}

class KeyboardProvider with ChangeNotifier {
  final LanguageLocale _locale = const LanguageLocale.en();
  final _dictionary = Dictionary();

  String? _keyword;
  String get keyword => _keyword ?? "";

  final int _numberOfLetters = 5;
  int get numberOfLetters => _numberOfLetters;

  final int _numberOfGuesses = 6;
  int get numberOfGuesses => _numberOfGuesses;

  bool _hardMode = false;
  bool get hardMode => _hardMode;

  int _activeRow = 0;

  List<WordRowState> _guessStates =
      List<WordRowState>.filled(6, WordRowState.empty(), growable: false);
  List<WordRowState> get guessStates => _guessStates;

  String _guessWord = "";
  String get guessWord => _guessWord;

  String _coloredFirstRow = const LanguageLocale.en().firstRow;
  String get coloredFirstRow => _coloredFirstRow;

  String _coloredSecondRow = const LanguageLocale.en().secondRow;
  String get coloredSecondRow => _coloredSecondRow;

  String _coloredThirdRow = const LanguageLocale.en().thirdRow;
  String get coloredThirdRow => _coloredThirdRow;

  void newGame(String? keyword) async {
    _keyword = keyword ??= await _dictionary.nextWord();
    reset();
  }

  void reset() {
    _coloredFirstRow = _locale.firstRow;
    _coloredSecondRow = _locale.secondRow;
    _coloredThirdRow = _locale.thirdRow;
    _activeRow = 0;
    _guessWord = "";
    _guessStates =
        List<WordRowState>.filled(6, WordRowState.empty(), growable: false);
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
    _keyword ??= await _dictionary.nextWord();
    if (_guessWord.length == numberOfLetters && _activeRow < numberOfGuesses) {
      if (_hardMode && _isHardMatch(_guessWord)) {
        return SubmissionResult.notMatch;
      }
      final hasMeaning =
          (_guessWord == _keyword) || await _dictionary.isWord(_guessWord);
      if (hasMeaning) {
        final isWon = _compareAnswers(_keyword!);
        _guessStates[_activeRow] = WordRowState.fromGuess(_guessWord);
        _activeRow += 1;
        _guessWord = "";
        notifyListeners();
        return isWon
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
      _guessStates[_activeRow] = WordRowState.keyword(_guessWord);
      notifyListeners();
    }
  }

  void removeLetter() {
    if (_guessWord.isNotEmpty && _activeRow < numberOfGuesses) {
      _guessWord = _guessWord.characters.skipLast(1).toString();
      _guessStates[_activeRow] = WordRowState.keyword(_guessWord);
      notifyListeners();
    }
  }

  String get winningMessage {
    switch (_activeRow) {
      case 0:
        return "one in a million!";
      case 1:
        return "great job!";
      case 2:
      case 3:
      case 4:
        return "good job!";
      default:
        return "phew!";
    }
  }

  String get hardModeMismatchMsg {
    return "hello";
  }

  void toggleHardMode(bool newValue) {
    _hardMode = newValue;
  }

  bool _isHardMatch(String string) {
    return false;
  }

  bool _compareAnswers(String keyword) {
    String comparedWord = "";
    int correctLetters = 0;

    String keywordCpy = "";
    String guessWord = "";
    for (int i = 0; i != numberOfLetters; i++) {
      final kChar = keyword.characters.elementAt(i);
      final gChar = _guessWord.characters.elementAt(i);
      if (kChar == gChar) {
        correctLetters += 1;
        keywordCpy += String.fromCharCode(kChar.codeUnitAt(0) | 0x100);
        guessWord += String.fromCharCode(gChar.codeUnitAt(0) | 0x100);
      } else {
        keywordCpy += kChar;
        guessWord += gChar;
      }
    }

    for (int i = 0; i != numberOfLetters; i++) {
      final char = guessWord.characters.elementAt(i);
      final isFound = keywordCpy.contains(char);
      if (isFound && char == keywordCpy.characters.elementAt(i)) {
        comparedWord += char;
      } else if (isFound) {
        comparedWord += String.fromCharCode(
            guessWord.characters.elementAt(i).codeUnitAt(0) | 0x200);
        keywordCpy = keywordCpy.replaceFirst(RegExp(char), '0');
      } else {
        comparedWord += guessWord.characters.elementAt(i);
      }
    }
    _guessWord = comparedWord;
    updateKeyboard(comparedWord);
    return correctLetters == numberOfLetters;
  }
}
