import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'component/show_snackbar.dart';
import 'services/average_service.dart';
import 'package:seg/component/report.dart';

String? urlPhoto;

class StorageScreen extends StatefulWidget {
  StorageScreen({super.key, required this.user});

  final User user;

  final StorageService storageService = StorageService();
  final AverageService averageService = AverageService();

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<String> listFiles = [];
  Color corPrincipal = Color(0xFF243D7E);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    refresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
        toolbarHeight: 50,
        elevation: 0.0,
        backgroundColor: corPrincipal,
      ),
      body: Container(
        margin: const EdgeInsets.all(32),
        child: Column(
          children: [
            (urlPhoto != null)
                ? ClipRRect(
              borderRadius: BorderRadius.circular(128),
              child: Image.network(
                urlPhoto!,
                height: 256,
                width: 256,
                fit: BoxFit.cover,
              ),
            )
                : const CircleAvatar(
              radius: 128,
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 16.0),
            Text(
              (widget.user.displayName != null) ? widget.user.displayName! : "",
              style: TextStyle(
                  fontFamily: 'Arial', color: corPrincipal, fontSize: 26.0),
            ),
            Text((widget.user.email!), style: TextStyle(fontSize: 12.0)),

            const SizedBox(height: 16.0),

            FutureBuilder<double>(
              future: calcularMedia(widget.user),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Erro ao calcular a média: ${snapshot.error}');
                } else {
                  double media = snapshot.data ?? 0.0;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 32.0),
                      Text(' $media', style: TextStyle(fontSize: 20.0, fontFamily: 'Arial')),
                    ],
                  );
                }
              },
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: uploadImage,
                  icon: Icon(Icons.photo),
                  label: Text('Nova Foto'),
                  style: ElevatedButton.styleFrom(
                    primary: corPrincipal,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  uploadImage() {
    ImagePicker imagePicker = ImagePicker();
    imagePicker
        .pickImage(
        source: ImageSource.gallery,
        maxHeight: 700,
        maxWidth: 700,
        imageQuality: 50)
        .then((XFile? image) {
      if (image != null) {
        widget.storageService.upload(file: File(image!.path), fileName: DateTime.now().toString())
            .then((String urlDownload) {
          setState(() {
            urlPhoto = urlDownload;
          });
        });
      } else {
        showSnackBar(context: context, mensage: "Nenhuma imagem selecionada.");
      }
    });
    refresh();
  }

  refresh() {
    setState(() {
      urlPhoto = _firebaseAuth.currentUser!.photoURL;
    });
  }

  Future<double> calcularMedia(User user) async {
    List<Avaliacao> avaliacoes = await widget.storageService.getAvaliacoesDoUsuario(user);

    return widget.averageService.calculateAverage(avaliacoes);
  }
}
