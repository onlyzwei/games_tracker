// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';

class GuestDashboardScreen extends StatefulWidget {
  static const routeName = '/guest-dashboard';

  const GuestDashboardScreen({super.key});

  @override
  _GuestDashboardScreenState createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Dashboard'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Welcome to the Guest Dashboard!',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
