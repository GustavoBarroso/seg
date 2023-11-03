import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<String?> entrarUsuario(
      {required String email, required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: senha);
      print("METODO ENTRAR USUARIO");
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "INVALID_LOGIN_CREDENTIALS":
          return "As credenciais estão incorretas.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> cadastrarUsuario({required String email,
    required String senha,
    required String nome}) async {
    try {
      await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: senha);
      User? user = _firebaseAuth.currentUser;
      await user?.sendEmailVerification();

      } on FirebaseAuthException catch (e)
      {
        switch (e.code) {
          case "email-already-in-use":
            return "O e-mail já está em uso.";
        }
        return e.code;
      }
      return null;
    }

  Future<String?> redefinirsenha({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "channel-error":
          return "E-mail não cadastrado.";
      }
      return e.code;
    }
    return null;
  }

  Future<String?> deslogar() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }

  Future<String?> apagarConta({required String senha}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: _firebaseAuth.currentUser!.email!, password: senha);
      await _firebaseAuth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return null;
  }
}
