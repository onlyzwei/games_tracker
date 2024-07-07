// ignore_for_file: prefer_const_constructors, avoid_print, use_super_parameters

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/user_controller.dart';
import 'package:games_tracker/models/user.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  final bool registeredUser;

  const DashboardScreen({Key? key, required this.registeredUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          registeredUser
              ? 'Bem-vindo, usuário registrado!'
              : 'Bem-vindo, visitante!',
        ),
      ),
    );
  }
}
