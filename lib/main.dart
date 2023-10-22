import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_app.dart';
import 'permissions_check.dart'; // Importe a tela de verificação de permissões
import 'package:permission_handler/permission_handler.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Verificar permissões antes de iniciar o aplicativo principal
  var status = await Permission.location.status;
  if (status.isDenied || status.isRestricted) {
    // Se as permissões de localização não foram concedidas, abra a tela de verificação de permissões
    runApp(MaterialApp(home: PermissionCheckScreen()));
  } else {
    // Se as permissões de localização foram concedidas, inicie o aplicativo principal (LoginApp)
    runApp(LoginApp());
  }
}
