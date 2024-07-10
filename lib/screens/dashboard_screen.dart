// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/models/user.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  final User? user;

  const DashboardScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          user != null
              ? 'Bem-vindo, ${user!.name}!'
              : 'Bem-vindo, visitante!',
        ),
      ),
    );
  }
}