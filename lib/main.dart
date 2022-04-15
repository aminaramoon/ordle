import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:wordle/screens/game_screen.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/services/io_service.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/states/oauth_provider.dart';
import 'package:wordle/widgets/lifetime_reactor.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  IoService ioService = IoService();
  ioService.init();
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
          '/': (context) => LifetimeReactor(child: GameScreen()),
        },
      ),
    );
  }
}
