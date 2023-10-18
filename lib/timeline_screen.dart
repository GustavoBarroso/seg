import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seg/component/show_confirm_password.dart';
import 'package:seg/services/auth_service.dart';

class Timeline_Screen extends StatefulWidget {
  @override
  _Timeline_Screen createState() => _Timeline_Screen();
}

class _Timeline_Screen extends State<Timeline_Screen> {
  Color corPrincipal = Color(0xFF243D7E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                title: const Text("Apagar conta"),
                onTap: () {
                  showConfirmPasswordDialog(context: context, email: "");
                }),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text("Sair"),
              onTap: () {
                AuthService().deslogar();
              },
            )
          ],
        ),
      ),
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
      ),
    );
  }
}
