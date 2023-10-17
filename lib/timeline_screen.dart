import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Timeline_Screen extends StatelessWidget {
  Color corPrincipal = Color(0xFF243D7E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
      ),
    );
  }
}