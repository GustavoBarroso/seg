import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class BotaoEmergencia extends StatelessWidget {
  final IconData iconData;
  final String label;
  final String phoneNumber;

  BotaoEmergencia({
    required this.iconData,
    required this.label,
    required this.phoneNumber,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _openPhoneDialer(phoneNumber);
      },
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF243D7E),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 48, color: Colors.white),
          SizedBox(height: 8),
          Text(label, textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white)),
        ],
      ),
    );
  }

  _openPhoneDialer(String phoneNumber) async {
    final url = 'tel:$phoneNumber';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      // Se não for possível abrir o discador, tentar fazer a chamada diretamente
      bool result = (await FlutterPhoneDirectCaller.callNumber(phoneNumber)) ?? false;
      if (result) {
        print('Chamada realizada para $phoneNumber com sucesso');
      } else {
        print('Não foi possível realizar a ligação para $phoneNumber');
      }
    }
  }
}

class EmergenciaScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Telefones de Emergência'),
        backgroundColor: Color(0xFF243D7E),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Center(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                padding: EdgeInsets.all(16.0),
                shrinkWrap: true,
                children: [
                  BotaoEmergencia(
                    iconData: Icons.local_police,
                    label: 'Polícia',
                    phoneNumber: '190',
                  ),
                  BotaoEmergencia(
                    iconData: Icons.local_fire_department,
                    label: 'Bombeiro',
                    phoneNumber: '193',
                  ),
                  BotaoEmergencia(
                    iconData: Icons.local_hospital,
                    label: 'SAMU',
                    phoneNumber: '192',
                  ),
                  BotaoEmergencia(
                    iconData: Icons.handshake,
                    label: 'Direitos Humanos',
                    phoneNumber: '100',
                  ),
                  BotaoEmergencia(
                    iconData: Icons.shield,
                    label: 'Defesa Civil',
                    phoneNumber: '199',
                  ),
                  BotaoEmergencia(
                    iconData: Icons.woman,
                    label: 'Atendimento a Mulher',
                    phoneNumber: '180',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
