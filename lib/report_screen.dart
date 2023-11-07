import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:image/image.dart' as img;
import 'dart:io';
import 'dart:convert';
import 'package:seg/services/storage_service.dart';
import 'package:seg/timeline_screen.dart';
import 'package:uuid/uuid.dart';

import 'component/report.dart';
import 'component/show_snackbar.dart';

void main() => runApp(MaterialApp(home: AddReport()));

late final User user;

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  final List<Report> listReport = [];
  FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Color corPrincipal = Color(0xFF243D7E);
  TextEditingController descricaoController = TextEditingController();
  TextEditingController localizacaoController = TextEditingController();
  File? _image;
  String? urlPhoto;
  String? _incidenteSelecionado;

  List<String> incidentes = [
    'Alagamento',
    'Engarrafamento',
    'Incêndio',
    'Via Interditada',
    'Outros'
    // Adicione mais incidentes conforme necessário
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

  /*Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      final croppedImage = img.copyResizeCropSquare(decodedImage!, 500);
      final croppedFile = File(pickedFile.path)..writeAsBytesSync(img.encodePng(croppedImage));

      setState(() {
        _image = croppedFile;
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    final picker = ImagePicker();
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      final decodedImage = img.decodeImage(bytes);
      final croppedImage = img.copyResizeCropSquare(decodedImage!, 500);
      final croppedFile = File(pickedFile.path)..writeAsBytesSync(img.encodePng(croppedImage));

      setState(() {
        _image = croppedFile;
      });
    }
  }*/

  uploadImageCamera() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
            source: ImageSource.camera,
            maxHeight: 1000,
            maxWidth: 1000,
            imageQuality: 50)
        .then((XFile? image) {
      if (image != null) {
        StorageService()
            .uploadReport(
                File: File(image.path), fileName: DateTime.now().toString())
            .then((String urlDownload) {
          setState(() {
            urlPhoto = urlDownload;
          });
          //refresh();
        });
      } else {
        showSnackBar(context: context, mensage: "Nenhuma imagem selecionada.");
      }
    });
  }

  uploadImageGallery() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
            source: ImageSource.gallery,
            maxHeight: 1000,
            maxWidth: 1000,
            imageQuality: 50)
        .then((XFile? image) {
      if (image != null) {
        StorageService()
            .uploadReport(
                File: File(image.path), fileName: DateTime.now().toString())
            .then((String urlDownload) {
          setState(() {
            urlPhoto = urlDownload;
          });
          //refresh();
        });
      } else {
        showSnackBar(context: context, mensage: "Nenhuma imagem selecionada.");
      }
    });
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
      body: Padding(
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
                });
              },
              items: incidentes.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            //urlPhoto != null ? Image.file(urlPhoto! as File) : Container(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: uploadImageGallery,
                  icon: Icon(Icons.photo),
                  label: Text('Galeria'),
                  style: ElevatedButton.styleFrom(
                    primary: corPrincipal,
                  ),
                ),
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
          ],
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
              Report report =
                  Report(id: const Uuid().v1(), descricao: descricaoController.text, incidente: _incidenteSelecionado!, localizacao: localizacaoController.text);
              _firebaseFirestore
                  .collection("report")
                  .doc(report.id)
                  .set(report.toMap()); //TODO: ADICONAR URL DE DOWNLOAD DA FOTO NO BANCO
              /*await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TimelineScreen(user: user))); TODO: RETORNAR PARA O TIMELINE*/
            }, //TODO: COLOCAR AQUI O MÉTODO DE PUBLICAÇÃO DA IMAGEM
            //TODO: DO JEITO QUE ESTÁ TÁ PUBLICANDO DIRETO
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
