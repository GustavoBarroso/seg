import 'package:flutter/material.dart';


void main() {
  runApp(LoginApp());
}

class LoginApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TabNavigator());
  }
}

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    LoginScreen(),
    SignupScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('SEG'), backgroundColor: Colors.blue),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.login), label: 'Login'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'Criar Conta'),
        ],
      ),
    );
  }
}

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


class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Crie sua conta',
                style: TextStyle(
                  fontSize: 24.0,
                ),
              ),
              SizedBox(height: 20.0),
              // Campo de Nome
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Nome',
                    filled: true,
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              // Campo de Email
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Email',
                    filled: true,
                    fillColor: Colors.grey[200],
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
                    fillColor: Colors.grey[200],
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
                    fillColor: Colors.grey[200],
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
                    fillColor: Colors.grey[200],
                    border: OutlineInputBorder(),
                    errorText:
                    !_passwordsMatch ? 'As senhas não coincidem' : null,
                  ),
                  obscureText: true,
                ),
              ),
              SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: _createAccount,
                child: Text('Criar Conta'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue,
                  onPrimary: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
