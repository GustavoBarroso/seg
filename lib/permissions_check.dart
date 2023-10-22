import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionCheckScreen extends StatefulWidget {
  @override
  _PermissionCheckScreenState createState() => _PermissionCheckScreenState();
}

class _PermissionCheckScreenState extends State<PermissionCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    var status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      // A permissão foi concedida, você pode continuar com as operações que exigem a permissão
    } else {
      // Se a permissão foi negada pelo usuário, redirecionar para as configurações do aplicativo
      openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verificar Permissões'),
      ),
      body: Center(
        child: Text('Verificando permissões...'),
      ),
    );
  }
}
