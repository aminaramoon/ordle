import 'dart:io';
import 'dart:convert';

import 'package:wordle/services/storage.dart';

class Dictionary {

  Storage storage = Storage();

  Future<bool> isWord(String word) async {
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

  Future<String> chooseWord() async {
    return storage.getInvetory().then((value) => value.next()!.toUpperCase());
  }
}
