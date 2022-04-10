class WordPack {
  WordPack(this.words, this.currentIndex, this.globalIndex);

  WordPack.empty()
      : words = List.empty(growable: true),
        currentIndex = 0,
        globalIndex = 0;

  WordPack.fromJson(Map<String, dynamic> json)
      : words = json['words'],
        currentIndex = json['current'],
        globalIndex = json['global'];

  List<String> words;
  int currentIndex;
  int globalIndex;

  void reset(Map<String, dynamic> json) {
    words = [...json['words']];
    currentIndex = json['current'];
    globalIndex = json['global'];
  }

  String? next() => hasMore ? words.elementAt(currentIndex++) : null;

  bool get isEmpty => words.isEmpty;

  bool get hasMore => currentIndex < (words.length - 1);

  Map<String, dynamic> toJson() => {
        'words': words,
        'current': currentIndex,
        'global': globalIndex,
      };
}
