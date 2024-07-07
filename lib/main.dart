// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/screens/login_screen.dart';
import 'package:games_tracker/screens/register_screen.dart';
import 'package:games_tracker/screens/dashboard_screen.dart';
import 'package:games_tracker/screens/user_screen.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Games Tracker',
    onGenerateRoute: (settings) {
      if (settings.name == LoginScreen.routeName) {
        return MaterialPageRoute(builder: (context) => LoginScreen());
      }

      if (settings.name == RegisterScreen.routeName) {
        return MaterialPageRoute(builder: (context) => RegisterScreen());
      }

      if (settings.name == DashboardScreen.routeName) {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => DashboardScreen(
            registeredUser: args['registeredUser'],
          ),
        );
      }
      if (settings.name == UserScreen.routeName) {
        return MaterialPageRoute(builder: (context) => UserScreen());
      }

      assert(false, 'Need to implement ${settings.name}');
      return null;
    },
    home: LoginScreen(),
  ));
}