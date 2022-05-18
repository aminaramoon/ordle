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

enum LetterStatus { intact, pressed, misplaced, correct }

class LetterState {
  LetterState({required this.letter, required this.status});

  LetterState.empty()
      : letter = "",
        status = LetterStatus.intact;

  LetterState.fromChar(this.letter) : status = LetterStatus.intact;

  final String letter;
  final LetterStatus status;
}

class WordState {
  WordState({required this.letters, required this.submissionResult})
      : _activeLetter = letters.length;

  WordState.empty(int numberLetters)
      : letters = List.filled(numberLetters, LetterState.empty()),
        submissionResult = SubmissionResult.incomplete;

  void appendLetter(String letter) {
    if (_activeLetter < letters.length) {
      letters[_activeLetter] =
          LetterState(letter: letter, status: LetterStatus.intact);
      _activeLetter++;
    }
  }

  void removeLetter() {
    if (_activeLetter > 0) {
      letters[_activeLetter - 1] = LetterState.empty();
      _activeLetter--;
    }
  }

  void compareWord(String keyword) {
    final List<String> keywordLetters = List.generate(
        keyword.length, (index) => keyword.characters.elementAt(index));
    int index = 0;
    for (var letter in keywordLetters) {
      if (letters.elementAt(index).letter == letter) {
        letters[index] =
            LetterState(letter: letter, status: LetterStatus.correct);
        keywordLetters[index] = "";
      }
      index++;
    }

    index = 0;
    for (var element in letters) {
      if (element.status != LetterStatus.correct) {
        int keyIndex = keywordLetters.indexOf(element.letter);
        LetterStatus status = LetterStatus.pressed;
        if (keyIndex != -1) {
          status = LetterStatus.misplaced;
          keywordLetters[keyIndex] = "";
        }
        letters[index] = LetterState(letter: element.letter, status: status);
      }
      index++;
    }
  }

  List<LetterState> letters;
  SubmissionResult submissionResult;
  int _activeLetter = 0;
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

  Map<String, int>? _charToIndexMap;

  bool _hardMode = false;
  bool get hardMode => _hardMode;

  bool _visible = true;
  bool get visible => _visible;

  int _activeRow = 0;

  // ignore: prefer_final_fields
  List<WordState> _guessWords =
      List.generate(6, (index) => WordState.empty(5), growable: false);
  List<WordState> get guessWords => _guessWords;

  String _guessWord = "";
  String get guessWord => _guessWord;

  final List<LetterState> _alphabetKeys = const LanguageLocale.en()
      .alphabet
      .characters
      .map<LetterState>((e) => LetterState.fromChar(e))
      .toList();
  List<LetterState> get alphabetKeys => _alphabetKeys;

  void newGame(String? keyword) async {
    _keyword = keyword ??= await _dictionary.nextWord();
    reset();
  }

  void reset() {
    _activeRow = 0;
    _guessWord = "";
    _guessWords =
        List.generate(6, (index) => WordState.empty(5), growable: false);
    for (int i = 0; i != _locale.alphabet.length; ++i) {
      _alphabetKeys[i] = LetterState.fromChar(_locale.alphabet[i]);
    }
    notifyListeners();
  }

  Future<SubmissionResult> submitAnswer() async {
    _keyword ??= await _dictionary.nextWord();
    if (_guessWord.length == numberOfLetters && _activeRow < numberOfGuesses) {
      if (_hardMode && _isHardMatch(_guessWord)) {
        return SubmissionResult.notMatch;
      }
      final isWon = (_guessWord == _keyword);
      final hasMeaning = isWon || await _dictionary.isWord(_guessWord);
      if (hasMeaning) {
        _guessWords[_activeRow].compareWord(keyword);
        _updateKeyboard();
        _activeRow += 1;
        _guessWord = "";
        notifyListeners();
        return isWon
            ? SubmissionResult.correct
            : _activeRow == numberOfGuesses
                ? SubmissionResult.done
                : SubmissionResult.incorrect;
      } else {
        notifyListeners();
        return SubmissionResult.invalid;
      }
    }
    return SubmissionResult.incomplete;
  }

  void pushLetter(String c) {
    if (_guessWord.length < numberOfLetters && _activeRow < numberOfGuesses) {
      _guessWord += c;
      _guessWords[_activeRow].appendLetter(c);
      notifyListeners();
    }
  }

  void removeLetter() {
    if (_guessWord.isNotEmpty && _activeRow < numberOfGuesses) {
      _guessWord = _guessWord.characters.skipLast(1).toString();
      _guessWords[_activeRow].removeLetter();
      notifyListeners();
    }
  }

  String get winningMessage {
    switch (_activeRow) {
      case 0:
        return "WOW!";
      case 1:
        return "one in a million!";
      case 2:
        return "great job!";
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

  void setVisible(bool visibility) {
    _visible = visibility;
    notifyListeners();
  }

  void toggleHardMode() {
    _hardMode = !_hardMode;
  }

  bool _isHardMatch(String string) {
    return true;
  }

  void _updateKeyboard() {
    _charToIndexMap ??= _locale.getLetterToIndexMap();
    final letters = _guessWords[_activeRow].letters;
    for (final ls in letters) {
      final index = _charToIndexMap![ls.letter];
      if (index != null) {
        if (ls.status.index > _alphabetKeys[index].status.index) {
          _alphabetKeys[index] =
              LetterState(letter: ls.letter, status: ls.status);
        }
      }
    }
  }
}
