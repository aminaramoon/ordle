import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wordle/screens/game_screen.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/widgets/lifetime_reactor.dart';

void main() async {
  runApp(const OrdleApp());
}

class OrdleApp extends StatelessWidget {
  const OrdleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => KeyboardProvider())],
      child: MaterialApp(
        initialRoute: '/',
        title: 'Ordle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.lightBlue,
        ),
        routes: {'/': (context) => const LifetimeReactor(child: GameScreen(),)},
      ),
    );
  }
}

