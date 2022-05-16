import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordle/services/app_theme.dart';
import 'package:wordle/services/locale.dart';
import 'package:wordle/states/keyboard_provider.dart';
import 'package:wordle/states/oauth_provider.dart';
import 'package:wordle/widgets/keyboard.dart';
import 'package:wordle/widgets/wordpad.dart';

import '../widgets/new_keyboard.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawerEnableOpenDragGesture: false,
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.appbarBackgroundColor,
        title: const Text("Ordle"),
        leading: Builder(
          builder: (BuildContext context) {
            return IconButton(
              icon: const Icon(Icons.account_circle),
              tooltip: 'user',
              onPressed: () => Scaffold.of(context).openDrawer(),
            );
          },
        ),
        actions: [
          TextButton(
            child: const Text("hard"),
            onPressed: () => context.read<KeyboardProvider>().toggleHardMode(),
          ),
          TextButton(
            child: const Text("redo"),
            onPressed: () => context.read<KeyboardProvider>().reset(),
          ),
          TextButton(
            child: const Text("skip"),
            onPressed: () => context.read<KeyboardProvider>().newGame(null),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          color: AppTheme.backgroundColor,
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              UserAccountsDrawerHeader(
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    context.watch<OAuthProvider>().imageUrl,
                  ),
                ),
                accountEmail: Text(context.watch<OAuthProvider>().emailAddress),
                accountName: Text(
                  context.watch<OAuthProvider>().name,
                  style: const TextStyle(fontSize: 24.0),
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.appbarBackgroundColor,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.verified_user_sharp),
                title: const Text(
                  'Log In',
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () => {},
              ),
              Expanded(
                child: Container(),
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text(
                  'Information',
                  style: TextStyle(fontSize: 15.0),
                ),
                onTap: () => {},
              ),
            ],
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsetsDirectional.only(top: 5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const WordPads(numberOfGuesses: 6),
            Expanded(child: Container()),
            const Keyboard(),
            Visibility(
              child: const NewKeyboard(locale: LanguageLocale.en()),
              visible: context.watch<KeyboardProvider>().visible,
            )
          ],
        ),
      ),
    );
  }
}
