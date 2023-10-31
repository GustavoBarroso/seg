import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg/services/auth_service.dart';
import 'package:seg/component/show_confirm_password.dart';

class CustomDrawer extends StatelessWidget {
  final User user;

  CustomDrawer({required this.user});

  Color corPrincipal = Color(0xFF243D7E);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
            ),
            accountName: Text((user.displayName != null) ? user.displayName! : ""),
            accountEmail: Text(user.email!),
            decoration: BoxDecoration(
              color: corPrincipal,
            ),
          ),
          ListTile(
            leading: const Icon(
              Icons.delete,
              color: Colors.red,
            ),
            title: const Text("Apagar conta"),
            onTap: () {
              showConfirmPasswordDialog(context: context, email: "");
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sair"),
            onTap: () {
              AuthService().deslogar();
            },
          ),
        ],
      ),
    );
  }
}
