// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class RegisterScreen extends StatelessWidget {
  static const routeName = '/register';

  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Novo Usuário')),
      body: Center(child: Text('Tela de Cadastro')),
    );
  }
}
