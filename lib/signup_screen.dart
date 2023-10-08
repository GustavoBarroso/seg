import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController =
  TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  bool _passwordsMatch =
  true; // Variável para verificar a correspondência das senhas

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _createAccount() {
    // Verifique se as senhas coincidem
    if (_passwordController.text == _confirmPasswordController.text) {
      // As senhas coincidem, você pode prosseguir com a criação da conta
      // Adicione aqui a lógica de criação de conta
    } else {
      // As senhas não coincidem, exiba uma mensagem de erro
      setState(() {
        _passwordsMatch = false;
      });
    }
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
      body: Container(
        color: Colors.white,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Crie sua conta',
                  style: TextStyle(
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
                      hintText: 'Nome',
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
                // Campo de Nome de Usuário
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nome de Usuário',
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
                    ),
                    obscureText: true,
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
                      errorText:
                      !_passwordsMatch ? 'As senhas não coincidem' : null,
                    ),
                    obscureText: true,
                  ),
                ),
                SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {
                    enviarClicado();
                  },
                  child: Text('Criar Conta'),
                  style: ElevatedButton.styleFrom(
                    primary: corPrincipal,
                    onPrimary: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enviarClicado() {
//  String email = _emailController.text;
//  String nome = _nameController;
//  String senha = _passwordController;
}
