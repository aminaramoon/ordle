import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/screens/game_screen.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/widgets/keyboard.dart';
import 'package:wordle/widgets/wordpad.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
        routes: {'/': (context) => AppLifecycleReactor(child: Text("data"),)},
      ),
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ordle"),
        actions: [
          IconButton(
            icon: const Icon(Icons.repeat),
            tooltip: 'restart',
            onPressed: () => context.read<KeyboardProvider>().reset(),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const WordPads(numberOfGuesses: 6),
            Expanded(child: Container()),
            const Keyboard(),
          ],
        ),
      ),
    );
  }
}
