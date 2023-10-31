import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'report_screen.dart';
import 'drawer.dart'; // Importe o arquivo do drawer

class TimelineScreen extends StatefulWidget {
  final User user;

  const TimelineScreen({super.key, required this.user});

  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  Color corPrincipal = Color(0xFF243D7E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(user: widget.user), // Use o drawer personalizado
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
      ),
      body: Center(
        child: Text('Conteúdo do Aplicativo'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddReport()),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: corPrincipal,
      ),
    );
  }
}
