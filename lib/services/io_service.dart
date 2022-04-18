import 'dart:async' show Future;
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wordle/models/metadata.dart';

class IoService {
  late final SharedPreferences _preferences;

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  Future<bool> storeMetaData(MetaData meta) async {
    return _preferences.setString("meta", meta.toString());
  }

  MetaData loadMetaData() {
    final meta = _preferences.getString("meta");
    return (meta != null) ? MetaData.fromString(meta) : MetaData.empty();
  }

  Future storeWordList(List<String> words) async {
    final dbFile = await _localFile;
    if (dbFile.existsSync()) {
      dbFile.delete().then((value) => storeWordList(words));
    } else {
      dbFile.open(mode: FileMode.write);
      dbFile.writeAsString(jsonEncode(words));
    }
  }

  Future<List<String>> loadWordList(MetaData metaData) async {
    final dbFile = await _localFile;
    if (dbFile.existsSync()) {
      if (!metaData.isEmpty && metaData.hasMore) {
        return dbFile
            .openRead()
            .transform(utf8.decoder)
            .transform(const LineSplitter())
            .toList();
      }
      return List<String>.empty();
    } else {
      return rootBundle
          .loadString('assets/data/wordlist_5.txt')
          .then((value) => value.split("\n"))
          .then((words) => words..shuffle())
          .then((words) {
        metaData.index = 0;
        metaData.size = words.length;
        return storeWordList(words).then((value) => words);
      });
    }
  }

  Future<List<String>> loadInitialWordList() async {
    return rootBundle
        .loadString('assets/data/wordlist_5.txt')
        .then((value) => value.split("\n"))
        .then((words) => words..shuffle());
  }

  Future<List<String>> loadDictionary() async {
    return rootBundle
        .loadString('assets/data/dictionary.txt')
        .then((value) => value.split("\n"));
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/db.txt');
  }
}
