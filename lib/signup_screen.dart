import 'package:flutter/material.dart';
import 'package:seg/component/show_snackbar.dart';
import 'package:seg/services/auth_service.dart';

AuthService authService = AuthService();

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

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
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Crie sua conta',
                style: TextStyle(
                  fontFamily: 'Arial',
                  fontSize: 30.0,
                  color: corPrincipal,
                ),
              ),
              SizedBox(height: 20.0),
              // Campo de Nome
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'Nome completo',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              // Campo de Email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              // Campo de Senha
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isPasswordVisible,
                ),
              ),
              SizedBox(height: 12.0),
              // Campo de Confirmar Senha
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  controller: _confirmPasswordController,
                  decoration: InputDecoration(
                    hintText: 'Confirmar Senha',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isConfirmPasswordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_isConfirmPasswordVisible,
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () {
                  enviarClicado();
                },
                child: Text("Cadastrar"),
                style: ElevatedButton.styleFrom(
                  primary: corPrincipal,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  enviarClicado() {
    String email = _emailController.text;
    String nome = _nameController.text;
    String senha = _confirmPasswordController.text;

    _criarUsuario(email: email, senha: senha, nome: nome);
  }

  _criarUsuario({required String email, required String senha, required String nome}) {
    if (_passwordController.text == _confirmPasswordController.text) {
      String email = _emailController.text;
      String nome = _nameController.text;
      String senha = _confirmPasswordController.text;
      authService
          .cadastrarUsuario(email: email, senha: senha, nome: nome)
          .then((String? erro) {
        if (erro == null) {
          showSnackBar(
              context: context,
              mensage: "Usuário cadastrado com sucesso. Enviado verificação de e-mail.",
              isError: false);
        } else {
          showSnackBar(context: context, mensage: erro);
        }
      });
    } else {
      showSnackBar(context: context, mensage: "As senhas não coincidem");
    }
  }
}
