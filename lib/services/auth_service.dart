import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> entrarUsuario({required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
      print("METODO ENTRAR USUARIO");
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case "INVALID_LOGIN_CREDENTIALS":
          return "As credenciais estão incorretas.";
        }
      return e.code;
    }
    return null;
  }

  Future<String?> cadastrarUsuario({required String email, required String senha, required String nome}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);

      await userCredential.user!.updateDisplayName(nome);

      print("METODO CRIAR USUARIO");
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case "email-already-in-use":
          return "O e-mail já está em uso.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> redefinirsenha ({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch(e.code) {
        case "channel-error":
          return "E-mail não cadastrado.";
      }
      return e.code;
    }
    return null;
  }
}