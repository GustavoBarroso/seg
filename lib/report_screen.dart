import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image/image.dart' as img;
import 'dart:io';

void main() => runApp(MaterialApp(home: AddReport()));

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  Color corPrincipal = Color(0xFF243D7E);
  TextEditingController descricaoController = TextEditingController();
  TextEditingController localizacaoController = TextEditingController();
  File? _image;
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

      Uri url = Uri.parse('https://nominatim.openstreetmap.org/reverse?format=json&lat=${position.latitude}&lon=${position.longitude}');
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

  Future<void> _getImageFromGallery() async {
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
            TextField(
              controller: descricaoController,
              decoration: InputDecoration(labelText: 'Descrição'),
            ),
            TextField(
              controller: localizacaoController,
              decoration: InputDecoration(labelText: 'Localização'),
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: _incidenteSelecionado,
              hint: Text('Selecione um incidente'),
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
            _image != null ? Image.file(_image!) : Container(),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: _getImageFromGallery,
                  icon: Icon(Icons.photo),
                  label: Text('Galeria'),
                  style: ElevatedButton.styleFrom(
                    primary: corPrincipal,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _getImageFromCamera,
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
            onPressed: () {
              // Lógica para publicar o relatório
              // descricaoController.text contém a descrição
              // localizacaoController.text contém a localização
              // _image contém o arquivo da imagem (pode ser null se nenhuma imagem for selecionada)
              // _incidenteSelecionado contém o incidente selecionado
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
