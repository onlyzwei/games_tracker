// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

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
        return MaterialPageRoute(builder: (context) => FixedSizeScreen(child: LoginScreen()));
      }

      if (settings.name == RegisterScreen.routeName) {
        return MaterialPageRoute(builder: (context) => FixedSizeScreen(child: RegisterScreen()));
      }

      if (settings.name == DashboardScreen.routeName) {
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => FixedSizeScreen(child: DashboardScreen(registeredUser: args['registeredUser'])),
        );
      }

      if (settings.name == UserScreen.routeName) {
        return MaterialPageRoute(builder: (context) => FixedSizeScreen(child: UserScreen()));
      }

      assert(false, 'Need to implement ${settings.name}');
      return null;
    },
    home: FixedSizeScreen(child: LoginScreen()), // Define a tela inicial com tamanho fixo
  ));
}

class FixedSizeScreen extends StatelessWidget {
  final Widget child;

  const FixedSizeScreen({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 800, // Largura fixa
          height: 600, // Altura fixa
          child: child, // Conteúdo dinâmico dentro do Container
        ),
      ),
    );
  }
}
