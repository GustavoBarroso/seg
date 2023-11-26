import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';
import 'package:seg/services/storage_service.dart';
import 'package:uuid/uuid.dart';

import 'component/report.dart';
import 'component/show_snackbar.dart';

void main() => runApp(MaterialApp(home: AddReport()));

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  double _latitude = 0.0;
  double _longitude = 0.0;
  List<Report> listReport = [];
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? user = FirebaseAuth.instance.currentUser!;
  bool _reportAnonimo = false;

  Color corPrincipal = Color(0xFF243D7E);
  TextEditingController descricaoController = TextEditingController();
  TextEditingController localizacaoController = TextEditingController();
  TextEditingController outrosIncidenteController = TextEditingController();
  bool _buttonsVisible = true;
  File? _imageFile;
  String? urlPhoto;
  String? _incidenteSelecionado;


  List<String> incidentes = [
    'Alagamento',
    'Engarrafamento',
    'Incêndio',
    'Via interditada',
    'Falta de energia',
    'Assalto',
    'Problemas com transporte público',
    'Outros'
  ];

  @override
  void initState() {
    super.initState();
    _obterLocalizacaoAtual();
  }

  Future<void> _obterLocalizacaoAtual() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        localizacaoController.text =
            'Latitude: ${position.latitude}, Longitude: ${position.longitude}';
        _latitude = position.latitude;
        _longitude = position.longitude;
      });

      Uri url = Uri.parse(
          'https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        Map<String, dynamic> data = json.decode(response.body);
        setState(() {
          localizacaoController.text = data['display_name'];
        });
      } else {
        setState(() {
          localizacaoController.text = 'Endereço não encontrado';
        });
      }
    } catch (e) {
      setState(() {
        localizacaoController.text = 'Erro ao obter a localização: $e';
      });
      print('Erro ao obter a localização: $e');
    }
  }

  Future<void> _uploadImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? image = await imagePicker.pickImage(
      source: source,
      maxHeight: 900,
      maxWidth: 900,
      imageQuality: 50,
    );

    if (image != null) {
      setState(() {
        _imageFile = File(image.path);
        _buttonsVisible = false;
      });
    } else {
      showSnackBar(context: context, mensage: "Nenhuma imagem selecionada.");
    }
  }

  void uploadImageCamera() {
    _uploadImage(ImageSource.camera);
  }

  void uploadImageGallery() {
    _uploadImage(ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
        title: Text('Adicionar Report'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: descricaoController,
                maxLines: null,
                decoration: InputDecoration(labelText: 'Descrição'),
              ),
              TextField(
                controller: localizacaoController,
                readOnly: true,
                decoration: InputDecoration(labelText: 'Localização'),
              ),
              SizedBox(height: 20),
              DropdownButton<String>(
                value: _incidenteSelecionado,
                hint: Text('Selecione um tipo de incidente'),
                onChanged: (String? newValue) {
                  setState(() {
                    _incidenteSelecionado = newValue;

                    // Limpar o campo de texto ao selecionar um valor diferente de "Outros"
                    if (_incidenteSelecionado != 'Outros') {
                      outrosIncidenteController.clear();
                    }
                  });
                },
                items: incidentes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),

              // Adicionar um campo de texto para "Outros" condicionalmente
              if (_incidenteSelecionado == 'Outros')
                TextField(
                  controller: outrosIncidenteController,
                  decoration: InputDecoration(labelText: 'Especifique o incidente'),
                ),

              SizedBox(height: 20),
              CheckboxListTile(
                title: Text('Reportar anonimamente'),
                value: _reportAnonimo,
                onChanged: (bool? value) {
                  setState(() {
                    _reportAnonimo = value!;
                  });
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  if (_buttonsVisible)
                    ElevatedButton.icon(
                      onPressed: uploadImageGallery,
                      icon: Icon(Icons.photo),
                      label: Text('Galeria'),
                      style: ElevatedButton.styleFrom(
                        primary: corPrincipal,
                      ),
                    ),
                  if (_buttonsVisible)
                    ElevatedButton.icon(
                      onPressed: uploadImageCamera,
                      icon: Icon(Icons.add_a_photo_rounded),
                      label: Text('Câmera'),
                      style: ElevatedButton.styleFrom(
                        primary: corPrincipal,
                      ),
                    ),
                ],
              ),
              SizedBox(
                height: 450, // Defina a altura máxima que você deseja
                width: 450, // Defina a largura máxima que você deseja
                child: _imageFile != null
                    ? Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                      )
                    : urlPhoto != null
                        ? ClipRect(
                            child: Align(
                              alignment: Alignment.center,
                              widthFactor: 1.0,
                              heightFactor: 1.0,
                              child: Image.network(
                                urlPhoto!,
                                fit: BoxFit
                                    .cover, // Isso faz com que a imagem cubra completamente o espaço alocado, mantendo a proporção
                              ),
                            ),
                          )
                        : Container(),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: Container(
          width: 120,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: corPrincipal,
            ),
            onPressed: () async {
              // Validar se os campos obrigatórios estão preenchidos
              if (descricaoController.text.isEmpty || _incidenteSelecionado == null) {
                // Mostrar um alerta ou mensagem informando ao usuário que os campos são obrigatórios
                showSnackBar(context: context, mensage: "'Descrição' e 'Tipo de Incidente' são obrigatórios");
                return;
              }

              if (_imageFile != null) {
                try {
                  String urlDownload = await StorageService().uploadReport(
                    File: _imageFile!,
                    fileName: DateTime.now().toString(),
                  );
                  setState(() {
                    urlPhoto = urlDownload;
                  });
                } catch (error) {
                  print("Erro ao fazer upload da imagem: $error");
                  // Handle upload errors
                }
              }

              String? username =
                  _reportAnonimo ? "Report Anônimo" : user!.displayName;
              String? useruid = user!.uid;

              Report report = Report(
                  id: const Uuid().v1(),
                  username: username!,
                  useruid: useruid,
                  descricao: descricaoController.text,
                  incidente: _incidenteSelecionado == 'Outros' ? outrosIncidenteController.text : _incidenteSelecionado,
                  localizacao: localizacaoController.text,
                  latitude: _latitude,
                  longitude: _longitude,
                  distance: 0.0,
                  urlPhoto: urlPhoto,
                  timestamp: Timestamp.now());

              _firebaseFirestore
                  .collection("report")
                  .doc(report.id)
                  .set(report.toMap());

              Navigator.pop(context);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Icon(Icons.check),
                Text('Publicar'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
