import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';

class AddReport extends StatefulWidget {
  @override
  _AddReportState createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  Color corPrincipal = Color(0xFF243D7E);
  TextEditingController descricaoController = TextEditingController();
  TextEditingController localizacaoController = TextEditingController();
  File? _image;

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
        'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    } catch (e) {
      print('Erro ao obter a localização: $e');
    }
  }

  Future<void> _getImageFromGallery() async {
    var image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> _getImageFromCamera() async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image != null) {
      setState(() {
        _image = File(image.path);
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
            SizedBox(height: 20),
            _image != null
                ? Image.file(_image!)
                : Container(),
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
