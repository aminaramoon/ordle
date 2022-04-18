import 'dart:convert';

class MetaData {
  MetaData({required this.index, required this.size});

  MetaData.empty()
      : index = 0,
        size = 0;

  bool get isEmpty => size == 0;

  bool get hasMore => index < size - 1;

  MetaData.fromJson(Map<String, dynamic> json)
      : index = json.containsKey("index") ? json["index"] : 0,
        size = json.containsKey("size") ? json["size"] : 0;

  Map<String, dynamic> toJson() => {
        'index': index,
        'size': size,
      };

  MetaData.fromString(String str) : this.fromJson(jsonDecode(str));

  @override
  String toString() => jsonEncode(toJson());

  int index;
  int size;
}
