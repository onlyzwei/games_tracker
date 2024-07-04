// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  static const routeName = '/dashboard';
  final bool registeredUser;

  const DashboardScreen({required this.registeredUser, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard'), centerTitle: true),
      body: Center(child: Text('Tela de Dashboard')),
    );
  }
}
