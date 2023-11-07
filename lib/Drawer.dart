import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:seg/EmergenciaScreen.dart';
import 'package:seg/services/auth_service.dart';
import 'package:seg/component/show_confirm_password.dart';
import 'package:seg/storage/storage_screen.dart';
import 'package:seg/timeline_screen.dart';

class CustomDrawer extends StatefulWidget {
  final User user;

  const CustomDrawer({super.key, required this.user});

  @override
  State<CustomDrawer> createState() => _CustomDrawer();
}

class _CustomDrawer extends State<CustomDrawer> {
  Color corPrincipal = Color(0xFF243D7E);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            currentAccountPicture: CircleAvatar(
              backgroundImage: (widget.user.photoURL != null)
                  ? NetworkImage(widget.user.photoURL!)
                  : null,
            ),
            accountName: Text(
              (widget.user.displayName != null) ? widget.user.displayName! : "",
            ),
            accountEmail: Text(widget.user.email!),
            decoration: BoxDecoration(
              color: corPrincipal,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text("Página Inicial"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => TimelineScreen(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.phone),
            title: Text("Emergência"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmergenciaScreen()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: const Text("Perfil"),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => StorageScrenn(user: widget.user)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text("Sair"),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Sair"),
                    content: Text("Tem certeza que deseja sair?"),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text("Sair"),
                        onPressed: () {
                          AuthService().deslogar();
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child:
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
            ),
          ),
        ],
      ),
    );
  }
}
