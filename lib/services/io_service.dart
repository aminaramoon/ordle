import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/models/metadata.dart';
import 'package:wordle/models/wordlist.dart';

class IoService {
  static final IoService _singleton = IoService._internal();

  factory IoService() {
    return _singleton;
  }

  IoService._internal();

  late final SharedPreferences _preferences;
  WordList? _cachedWordList;

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<String> nextWord() async {
    final str = _nextWordList().then((wordlist) => wordlist.next()!.toUpperCase());
    if (_cachedWordList != null) await _saveMetaData(_cachedWordList!.meta);
    return str;
  }

  Future<bool> _saveMetaData(MetaData meta) async {
    return _preferences.setString("meta", meta.toString());
  }

  Future<WordList> _nextWordList() async {
    if (_cachedWordList != null) {
      if (_cachedWordList!.hasMore) {
        return _cachedWordList!;
      } else {
        _cachedWordList!.reload(await _loadMoreWords());
      }
    } else {
      _cachedWordList =
          WordList(meta: _loadMetaData(), words: await _initWords());
    }
    return _cachedWordList!;
  }

  MetaData _loadMetaData() {
    final meta = _preferences.getString("meta");
    return (meta != null) ? MetaData.fromString(meta) : MetaData.empty();
  }

  Future<List<String>> _loadMoreWords() async {
    return List.empty();
  }

  Future<List<String>> _initWords() async {
    return rootBundle
        .loadString('assets/data/wordlist_5.txt')
        .then((value) => value.split("\n"));
  }
}
