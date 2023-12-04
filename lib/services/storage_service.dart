import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:seg/component/report.dart';

class StorageService {
  String pathService = FirebaseAuth.instance.currentUser!.uid;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String> upload({required File file, required String fileName}) async {
    await _firebaseStorage.ref("profiles/$pathService/$fileName.png").putFile(file);
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

  Future<String> uploadReport({required File file, required String fileName}) async {
    await _firebaseStorage.ref("reports/$fileName.png").putFile(file);
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

  Future<List<Avaliacao>> getAvaliacoesDoUsuario(User user) async {
    try {
      // Use o uid do usuário para consultar as avaliações
      String userUid = user.uid;

      QuerySnapshot<Map<String, dynamic>> avaliacoesSnapshot = await FirebaseFirestore.instance
          .collection('avaliacoes')
          .where('user', isEqualTo: userUid)
          .get();

      List<Avaliacao> avaliacoes = avaliacoesSnapshot.docs
          .map((doc) => Avaliacao.fromMap(doc.data() as Map<String, dynamic>))
          .toList();

      return avaliacoes;
    } catch (error) {
      print('Erro ao obter avaliações do usuário: $error');
      return [];
    }
  }
}
