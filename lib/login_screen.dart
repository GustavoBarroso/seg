import 'package:flutter/material.dart';
import 'package:seg/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool isEntrando = true;
  final _formKey = GlobalKey<FormState>();
  AuthService authService = AuthService();
  Color corPrincipal = Color(0xFF243D7E);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 160,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background1.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Bem-vindo(a) ao SEG',
                  style: TextStyle(color: corPrincipal, fontSize: 30.0)),
              Text('Compartilhando Cuidado, Construindo Confiança',
                  style: TextStyle(color: Colors.grey, fontSize: 16.0)),
              SizedBox(height: 30.0),
              // Campo de Email
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                      controller: _emailController,
                      validator: (value) {
                        if (value == null || value == "") {
                          return "O valor de e-mail deve ser preenchido";
                        }
                        if (!value.contains("@") ||
                            !value.contains(".") ||
                            value.length < 4) {
                          return "O valor do e-mail deve ser válido";
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder()))),
              SizedBox(height: 15.0),

              // Campo de Senha
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                      controller: _senhaController,
                      validator: (value) {
                        if (value == null || value.length < 4) {
                          return "Insira uma senha válida.";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                          hintText: 'Senha',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder()),
                      obscureText: true)),
              SizedBox(height: 15.0),

              ElevatedButton(
                onPressed: () {
                  entrarClicado();
                },
                child: Text("Entrar"),
                style: ElevatedButton.styleFrom(
                  primary: corPrincipal,
                  onPrimary: Colors.white,
                ),
              ),
              SizedBox(height: 15.0),
            ],
          ),
        ),
      ),
    );
  }

  entrarClicado() {
    String email = _emailController.text;
    String senha = _senhaController.text;

    _entrarUsuario(email: email, senha: senha);

  }

  _entrarUsuario({required String email, required String senha}) {
    authService.entrarUsuario(email: email, senha: senha);
    //Navigator.pushNamed(context, '/timeline_screen');
  }

}
