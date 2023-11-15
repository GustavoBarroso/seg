import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'login_app.dart';

Future<Widget> checkPermissionAndReturnScreen() async {
  var status = await Permission.location.status;
  Widget homeScreen;

  if (status.isGranted) {
    homeScreen = LoginApp();
  } else {
    var permissionStatus = await Permission.location.request();
    if (permissionStatus.isGranted) {
      homeScreen = LoginApp();
    } else {
      homeScreen = buildPermissionDeniedScreen();
    }
  }

  return homeScreen;
}

Widget buildPermissionDeniedScreen() {
  Color corPrincipal = Color(0xFF243D7E);

  return Scaffold(
    appBar: AppBar(
      title: Text('Permissão Negada'),
      backgroundColor: corPrincipal,
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'O aplicativo não pode funcionar corretamente sem permissão de localização.',
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                openAppSettings(); // Abre as configurações do aplicativo
              },
              style: ElevatedButton.styleFrom(
                primary: corPrincipal,
              ),
              child: Text('Abrir Configurações'),
            ),
            SizedBox(height: 40),
            Text(
              'Por favor, ative a localização e reinicie o aplicativo para continuar.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    ),
  );
}