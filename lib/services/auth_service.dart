import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  entrarUsuario({required String email, required String senha}) {
    _firebaseAuth.signInWithEmailAndPassword(email: email, password: senha);
    print("METODO ENTRAR USUARIO");
  }

  cadastrarUsuario({required String email, required String senha, required String nome}) {
    _firebaseAuth.createUserWithEmailAndPassword(email: email, password: senha);
    print("METODO CRIAR USUARIO");
  }

  error() {
  }
}