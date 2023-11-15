import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg/services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'component/show_snackbar.dart';

String? urlPhoto;

class StorageScreen extends StatefulWidget {
  StorageScreen({super.key, required this.user});

  final User user;

  final StorageService storageService = StorageService();

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  List<String> listFiles = [];
  Color corPrincipal = Color(0xFF243D7E);

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

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
                    ))
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
            Text((widget.user.email!),
                style: TextStyle(fontSize: 12.0)),
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
                ElevatedButton.icon(
                  onPressed: refresh,
                  icon: Icon(Icons.refresh),
                  label: Text('Atualizar'),
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
        StorageService()
            .upload(File: File(image.path), fileName: DateTime.now().toString())
            .then((String urlDownload) {
          setState(() {
            urlPhoto = urlDownload;
          });
          refresh();
        });
      } else {
        showSnackBar(context: context, mensage: "Nenhuma imagem selecionada.");
      }
    });
  }

  refresh() {
    setState(() {
      urlPhoto = _firebaseAuth.currentUser!.photoURL;
    });
  }
}
