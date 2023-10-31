import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg/tab_navigator.dart';
import 'package:seg/timeline_screen.dart';

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: RoteadorTelas());
  }
}

class RoteadorTelas extends StatelessWidget {
  const RoteadorTelas({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.userChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData) {
            return TimelineScreen(
              user: snapshot.data!,
            );
          } else {
            return TabNavigator();
          }
        }
      },
    );
  }
}
