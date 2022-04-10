import 'package:flutter/material.dart';
import 'package:wordle/services/storage.dart';

class AppLifecycleReactor extends StatefulWidget {
  AppLifecycleReactor({Key? key, required this.child}) : super(key: key);

  final Storage storage = Storage();
  final Widget child;

  @override
  State<AppLifecycleReactor> createState() => _AppLifecycleReactorState();
}

class _AppLifecycleReactorState extends State<AppLifecycleReactor>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _notification = AppLifecycleState.resumed;
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    print("dispose");
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  late AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("didChangeAppLifecycleState $state");
    setState(() {
      _notification = state;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Last notification: $_notification test'),
        widget.child,
      ],
    );
  }
}
