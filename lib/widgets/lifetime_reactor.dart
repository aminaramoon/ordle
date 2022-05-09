import 'package:flutter/material.dart';

class LifetimeReactor extends StatefulWidget {
  const LifetimeReactor(
      {Key? key,
      required this.child,
      required this.onInactive,
      required this.onResume})
      : super(key: key);

  final Widget child;
  final VoidCallback onInactive;
  final VoidCallback onResume;

  @override
  State<LifetimeReactor> createState() => _LifetimeReactorState();
}

class _LifetimeReactorState extends State<LifetimeReactor>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    _notification = AppLifecycleState.resumed;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  late AppLifecycleState _notification;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_notification == AppLifecycleState.resumed &&
        state != AppLifecycleState.resumed) {
      setState(() {
        widget.onInactive();
      });
    } else if (_notification != AppLifecycleState.resumed &&
        state == AppLifecycleState.resumed) {
      setState(() {
        widget.onResume();
      });
    }
    _notification = state;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
