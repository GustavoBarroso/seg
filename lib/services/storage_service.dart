import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  String pathService = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> upload({required File, required String fileName}) async {
    await _firebaseStorage.ref("$pathService/$fileName.png").putFile(File);
    String url = await _firebaseStorage
        .ref("profiles/$pathService/$fileName.png")
        .getDownloadURL();
        await _firebaseAuth.currentUser!.updatePhotoURL(url);
    return url;
  }

  Future<String> getDownloadUrlByFileName({required String fileName}) async {
    return await _firebaseStorage
        .ref("profiles/$pathService/$fileName.png")
        .getDownloadURL();
  }

  Future<String> uploadReport({required File, required String fileName}) async {
    await _firebaseStorage.ref("reports/$fileName.png").putFile(File);
    String url = await _firebaseStorage
        .ref("reports/$fileName.png")
        .getDownloadURL();
    //await _firebaseAuth.currentUser!.updatePhotoURL(url);
    return url;
  }

  Future<String> getDownloadUrlByFileNameReports({required String fileName}) async {
    return await _firebaseStorage
        .ref("reports/$fileName.png")
        .getDownloadURL();
  }

}
