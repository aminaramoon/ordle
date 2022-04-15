import 'package:flutter/material.dart';

class OAuthProvider with ChangeNotifier {
  String? _name;
  String? _email;
  String? _imageUrl;

  String get name => _name ?? "name";

  String get emailAddress => _email ?? "email address";

  String get imageUrl =>
      _imageUrl ??
      'https://images.unsplash.com/photo-1485290334039-a3c69043e517?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=MnwxfDB8MXxyYW5kb218MHx8fHx8fHx8MTYyOTU3NDE0MQ&ixlib=rb-1.2.1&q=80&utm_campaign=api-credit&utm_medium=referral&utm_source=unsplash_source&w=300';
}
