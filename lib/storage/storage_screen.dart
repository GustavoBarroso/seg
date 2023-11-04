import 'dart:core';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:seg/services/storage_service.dart';
import '../Drawer.dart';
import 'package:image_picker/image_picker.dart';
import '../component/show_snackbar.dart';

String? urlPhoto;

class StorageScrenn extends StatefulWidget {
  StorageScrenn({super.key, required this.user});

  final User user;

  final StorageService storageService = StorageService();

  @override
  State<StorageScrenn> createState() => _StorageScrennState();
}

class _StorageScrennState extends State<StorageScrenn> {
  List<String> listFiles = [];
  Color corPrincipal = Color(0xFF243D7E);

  final StorageService _storageService = StorageService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(user: widget.user),
      appBar: AppBar(
        title: const Text("Foto de perfil"),
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
        maxHeight: 2000,
        maxWidth: 2000,
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
