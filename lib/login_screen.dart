import 'package:flutter/material.dart';
import 'package:seg/services/auth_service.dart';

import 'component/show_snackbar.dart';

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
                  style: TextStyle(
                      fontFamily: 'Arial',
                      color: corPrincipal,
                      fontSize: 30.0)),
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
              //SizedBox(height: 15.0),

              TextButton(
                  style: TextButton.styleFrom(
                    primary: corPrincipal,
                  ),
                  onPressed: _redefinirSenha,
                  child: const Text("Esqueci minha senha.",
                      style: TextStyle(decoration: TextDecoration.underline))),
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
    String email = _emailController.text;
    String senha = _senhaController.text;

    authService.entrarUsuario(email: email, senha: senha).then((String? erro) {
      if (erro == null) {
        showSnackBar(
            context: context,
            mensage: "Login realizado com sucesso.",
            isError: false);
        Navigator.pushNamed(context, '/timeline_screen');
      } else {
        showSnackBar(context: context, mensage: erro);
      }
    });
  }

  _redefinirSenha() {
    String email = _emailController.text;
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController _redefinicaoSenhaController =
            TextEditingController(text: email);
        return AlertDialog(
          title: const Text("Confirme o e-mail para redefinição de senha."),
          content: TextFormField(
            controller: _redefinicaoSenhaController,
            decoration:
                const InputDecoration(label: Text("Confirme o e-mail.")),
          ),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          actions: [
            TextButton(
                style: TextButton.styleFrom(
                  primary: corPrincipal,
                ),
                onPressed: () {
                  authService
                      .redefinirsenha(email: _redefinicaoSenhaController.text)
                      .then((String? erro) {
                    if (erro == null) {
                      showSnackBar(
                          context: context,
                          mensage: "E-mail para redefinição de senha enviado. Confira a pasta spam.",
                          isError: false);
                    } else {
                      showSnackBar(context: context, mensage: erro);
                    }
                    Navigator.pop(context);
                  });
                },
                child: const Text("Redefinir senha"))
          ],
        );
      },
    );
  }
}
