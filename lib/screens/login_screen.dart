// ignore_for_file: prefer_const_constructors, unused_import

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/user_controller.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/screens/dashboard_screen.dart';
import 'package:games_tracker/screens/register_screen.dart';
import 'package:games_tracker/screens/user_screen.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() {
    if (_formKey.currentState!.validate()) {
      if (_emailController.text == "adm" && _passwordController.text == "adm") {
        Navigator.pushNamed(
          context,
          UserScreen.routeName,
        );
      } else {
        Navigator.pushNamed(
          context,
          DashboardScreen.routeName,
          arguments: {'registeredUser': true},
        );
      }
    }
  }


  void _register() {
    Navigator.pushNamed(
        context,
        RegisterScreen.routeName
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email inválido';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Senha inválida';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16.0),
                  Center(
                    child: Wrap(
                      spacing: 20, // Espaçamento entre os botões
                      children: [
                        ElevatedButton(
                          onPressed: _login,
                          child: Text('Login'),
                        ),
                        ElevatedButton(
                          onPressed: _register,
                          child: Text('Registrar-se'),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
