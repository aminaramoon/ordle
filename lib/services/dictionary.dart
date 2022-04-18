import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:wordle/models/metadata.dart';
import 'package:wordle/services/io_service.dart';

class Dictionary {
  static final Dictionary _singleton = Dictionary._internal();

  factory Dictionary() {
    return _singleton;
  }

  Dictionary._internal();

  Future init() async {
    _ioService.init().then((value) => _metaData = _ioService.loadMetaData());
    _populateDictionary(_ioService.loadDictionary());
  }

  final IoService _ioService = IoService();
  final List<int> _cachedDictionary = List.empty(growable: true);
  List<String>? _wordList;
  late final MetaData _metaData;

  Future<String> nextWord() async {
    _wordList ??= await _ioService.loadWordList(_metaData);
    final index = _metaData.index++;
    _ioService.storeMetaData(_metaData);
    return _wordList!.elementAt(index).toUpperCase();
  }

  Future<bool> isWord(String word) async {
    if (_lookupDictioary(word)) {
      print("_lookupDictioary(${word})");
      return true;
    }
    return _lookupOnline(word);
  }

  Future _populateDictionary(Future<List<String>> dictionary) async {
    for (final word in await dictionary) {
      _cachedDictionary.add(_wordToCode(word));
    }
  }

  bool _lookupDictioary(String word) {
    if (_cachedDictionary.isNotEmpty) {
      final int? code = _wordToCode(word);
      return code != null ? _binarySearch(_cachedDictionary, code) : false;
    }
    return false;
  }

  Future<bool> _lookupOnline(String word) async {
    String wordApiRequest =
        "https://api.dictionaryapi.dev/api/v2/entries/en/" + word.toLowerCase();
    var request = await HttpClient().getUrl(Uri.parse(wordApiRequest));
    var response = await request.close();
    bool hasMeaning = false;
    await for (var contents in response.transform(const Utf8Decoder())) {
      hasMeaning = hasMeaning || !contents.contains("No Definitions Found");
    }
    return hasMeaning;
  }

  int _wordToCode(String word) {
    final aCode = "a".codeUnitAt(0) - 1;
    int code = 0;
    for (final rune in word.toLowerCase().runes) {
      code = (code << 5) | (rune - aCode);
    }
    return code;
  }

  bool _binarySearch(List<int> arr, int userValue) {
    return _binarySearchImpl(arr, userValue, 0, arr.length - 1);
  }

  bool _binarySearchImpl(List<int> arr, int userValue, int min, int max) {
    if (max >= min) {
      int mid = ((max + min) / 2).floor();
      if (userValue == arr[mid]) {
        return true;
      } else if (userValue > arr[mid]) {
        return _binarySearchImpl(arr, userValue, mid + 1, max);
      } else {
        return _binarySearchImpl(arr, userValue, min, mid - 1);
      }
    }
    return false;
  }
}
