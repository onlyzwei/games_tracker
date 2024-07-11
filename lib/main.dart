// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:games_tracker/screens/add_game_screen.dart';
import 'package:games_tracker/screens/add_review_screen.dart';
import 'package:games_tracker/screens/guest_dashboard_screen.dart';
import 'package:games_tracker/screens/login_screen.dart';
import 'package:games_tracker/screens/register_screen.dart';
import 'package:games_tracker/screens/remove_game_screen.dart';
import 'package:games_tracker/screens/review_game_screen.dart';
import 'package:games_tracker/screens/user_dashboard_screen.dart';
import 'package:games_tracker/screens/adm_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Games Tracker',
      navigatorObservers: [routeObserver],
      onGenerateRoute: (settings) {
        if (settings.name == LoginScreen.routeName) {
          return MaterialPageRoute(builder: (context) => FixedSizeScreen(child: LoginScreen()));
        }

        if (settings.name == RegisterScreen.routeName) {
          return MaterialPageRoute(builder: (context) => FixedSizeScreen(child: RegisterScreen()));
        }

        if (settings.name == UserDashboardScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FixedSizeScreen(child: UserDashboardScreen(currentUser: args['user'])),
            settings: settings,
          );
        }

        if (settings.name == GuestDashboardScreen.routeName) {
          return MaterialPageRoute(
            builder: (context) => FixedSizeScreen(child: GuestDashboardScreen()),
          );
        }

        if (settings.name == AdmScreen.routeName) {
          return MaterialPageRoute(builder: (context) => FixedSizeScreen(child: AdmScreen()));
        }

        if (settings.name == AddGameScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FixedSizeScreen(child: AddGameScreen(currentUser: args['user'])),
          );
        }

        if (settings.name == RemoveGameScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FixedSizeScreen(child: RemoveGameScreen(currentUser: args['user'])),
          );
        }

        if (settings.name == ReviewGameScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FixedSizeScreen(child: ReviewGameScreen(currentUser: args['user'], gameId: args['gameId'])),
          );
        }

        if (settings.name == AddReviewScreen.routeName) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => FixedSizeScreen(
              child: AddReviewScreen(
                gameId: args['gameId'],
                currentUser: args['user'],
              ),
            ),
          );
        }

        assert(false, 'Need to implement ${settings.name}');
        return null;
      },
      home: FixedSizeScreen(child: LoginScreen()), // Define a tela inicial com tamanho fixo
    );
  }
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
