import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
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
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Email',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder()))),
              SizedBox(height: 15.0),

              // Campo de Senha
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Senha',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder()),
                      obscureText: true)),
              SizedBox(height: 15.0),

              ElevatedButton(
                onPressed: () {
                  // Adicione aqui a lógica de autenticação
                },
                child: Text('Entrar'),
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
}
