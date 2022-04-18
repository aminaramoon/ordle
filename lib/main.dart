import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wordle/screens/game_screen.dart';
import 'package:wordle/services/dictionary.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/states/oauth_provider.dart';
import 'package:wordle/widgets/lifetime_reactor.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Dictionary dictionary = Dictionary();
  dictionary.init();
  runApp(const OrdleApp());
}

class OrdleApp extends StatelessWidget {
  const OrdleApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => KeyboardProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OAuthProvider(),
        ),
      ],
      child: MaterialApp(
        initialRoute: '/',
        title: 'Ordle',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        routes: {
          '/': (context) => const LifetimeReactor(child: GameScreen()),
        },
      ),
    );
  }
}
