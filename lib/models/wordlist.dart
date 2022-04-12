import 'package:wordle/models/metadata.dart';

class WordList {
  WordList({required this.meta, required this.words});

  final MetaData meta;
  final List<String> words;

  String? next() => hasMore ? words.elementAt(meta.index++) : null;

  bool get isEmpty => words.isEmpty;

  bool get hasMore => words.isNotEmpty && meta.index < words.length - 1;
}
