// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/screens/add_game_screen.dart';
import 'package:games_tracker/screens/remove_game_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  static const routeName = '/user-dashboard';
  final User currentUser;

  const UserDashboardScreen({super.key, required this.currentUser});

  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}



class _UserDashboardScreenState extends State<UserDashboardScreen> {

  void _addGame() {
    Navigator.pushNamed(
      context,
      AddGameScreen.routeName,
      arguments: {'user': widget.currentUser},
    );
  }

  void _removeGame() {
    Navigator.pushNamed(
      context,
      RemoveGameScreen.routeName,
      arguments: {'user': widget.currentUser},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Dashboard'),
        centerTitle: true,
        actions: [
          PopupMenuButton<int>(
            onSelected: (int result) {
              switch (result) {
                case 0:
                  _addGame();
                  break;
                case 1:
                  _removeGame();
                  break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
              PopupMenuItem<int>(
                value: 0,
                child: Text('Adicionar Jogo'),
              ),
              PopupMenuItem<int>(
                value: 1,
                child: Text('Remover Jogo'),
              ),
            ],
          ),
        ],
      ),
    );
  }

}