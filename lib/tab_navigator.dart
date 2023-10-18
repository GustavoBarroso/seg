import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

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
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.login, color: Colors.indigo),label: 'Login'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_add, color: Colors.indigo), label: 'Criar Conta'),
        ],
      ),
    );
  }
}
