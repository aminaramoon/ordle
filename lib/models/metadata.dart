import 'dart:convert';

class MetaData {
  MetaData({required this.index, required this.offsetGlobal});

  MetaData.empty()
      : index = 0,
        offsetGlobal = 0;

  MetaData.fromJson(Map<String, dynamic> json)
      : index = json.containsKey("index") ? json["index"] : 0,
        offsetGlobal = json.containsKey("offset") ? json["offset"] : 0;

  Map<String, dynamic> toJson() => {
        'index': index,
        'offset': offsetGlobal,
      };

  MetaData.fromString(String str) : this.fromJson(jsonDecode(str));

  @override
  String toString() => jsonEncode(toJson());

  int index;
  int offsetGlobal;
}
