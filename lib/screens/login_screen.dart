// ignore_for_file: prefer_const_constructors, unused_import, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/user_controller.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/screens/guest_dashboard_screen.dart';
import 'package:games_tracker/screens/user_dashboard_screen.dart';
import 'package:games_tracker/screens/register_screen.dart';
import 'package:games_tracker/screens/adm_screen.dart';

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
  final UserController _userController = UserController();

  Future<void> _login(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String email = _emailController.text;
      String password = _passwordController.text;

      if (email == "adm" && password == "adm") {
        Navigator.pushNamed(
          context,
          AdmScreen.routeName,
        );
      } else {
        User? user = await _userController.getUser(email, password);
          if (user != null) {
            Navigator.pushNamed(
              context,
              UserDashboardScreen.routeName,
              arguments: {'user': user},
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário ou senha inválidos')),
            );
          }
      }
    }
  }

  void _register() {
    Navigator.pushNamed(
        context,
        RegisterScreen.routeName
    );
  }

  void _loginAsGuest() {
    Navigator.pushNamed(
      context,
      GuestDashboardScreen.routeName,
      arguments: {'user': null},
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
                          onPressed: () => _login(context), // Chama _login com o contexto
                          child: Text('Login'),
                        ),
                        ElevatedButton(
                          onPressed: _register, // Chama _register diretamente
                          child: Text('Registrar-se'),
                        ),
                        ElevatedButton(
                          onPressed: _loginAsGuest, // Chama _loginAsGuest diretamente
                          child: Text('Entrar como Visitante'),
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
