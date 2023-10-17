import 'package:flutter/material.dart';
import 'package:seg/timeline_screen.dart';
import 'tab_navigator.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TabNavigator(),
        routes: {'/timeline_screen': (context) => Timeline_Screen(),}
    );
  }
}
