import 'dart:async' show Future;
import 'dart:io';
import 'package:path/path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:wordle/models/word_pack.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

class Storage {
  static final Storage _singleton = Storage._internal();

  factory Storage() {
    return _singleton;
  }

  Storage._internal();

  Future<WordPack> getInvetory() async {
    if (_invetory.isEmpty) {
      var dbPath = await _dbPath;
      if (FileSystemEntity.typeSync(dbPath) == FileSystemEntityType.notFound) {
        var words = await rootBundle
            .loadString('assets/data/wordlist_5.txt')
            .then((lines) => lines.split("\n"));
        return _loadInitialWordList(
            rootBundle.loadString('assets/data/wordlist_5.json'));
      } else {
        return _loadInitialWordList(
            _dbFile.then((dbFile) => dbFile.readAsString()));
      }
    } else if (!_invetory.hasMore) {
      _loadFirebaseWordList();
    }
    return _invetory;
  }

  Future<void> saveInvetory() async {
    if (!_invetory.isEmpty) {
      var dbFile = await _dbFile;
      if (await dbFile.exists()) {
        await dbFile.delete();
      }
      var dbFd = await dbFile.create();
      await dbFd.writeAsString(jsonEncode(_invetory.toJson()));
    }
  }

  // ignore: prefer_final_fields
  WordPack _invetory = WordPack.empty();

  Future<String> get _dbPath async {
    final directory = await getApplicationDocumentsDirectory();
    return join(directory.path + "wordlist.json");
  }

  Future<File> get _dbFile async {
    final path = await _dbPath;
    return File(path);
  }

  Future<WordPack> _loadInitialWordList(Future<String> data) async {
    _invetory.reset(await data.then((value) => json.decode(value)));
    return _invetory;
  }

  Future<WordPack> _loadFirebaseWordList() async {
    return _invetory;
  }
}
