// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/screens/add_game_screen.dart';
import 'package:games_tracker/screens/remove_game_screen.dart';
import 'package:games_tracker/screens/review_game_screen.dart';

class UserDashboardScreen extends StatefulWidget {
  static const routeName = '/user-dashboard';
  final User currentUser;

  const UserDashboardScreen({super.key, required this.currentUser});

  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> {
  final GameController _gameController = GameController();
  List<Map<String, dynamic>> _games = [];

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    var games = await _gameController.getGames();
    setState(() {
      _games = games;
    });
  }

  void _addGame() {
    Navigator.pushNamed(
      context,
      AddGameScreen.routeName,
      arguments: {'user': widget.currentUser},
    ).then((_) => _loadGames()); // Recarrega a lista de jogos após adicionar um novo
  }

  void _removeGame() {
    Navigator.pushNamed(
      context,
      RemoveGameScreen.routeName,
      arguments: {'user': widget.currentUser},
    ).then((_) => _loadGames()); // Recarrega a lista de jogos após remover um jogo
  }

  void _reviewGame(int gameId) {
      Navigator.pushNamed(
        context,
        ReviewGameScreen.routeName,
        arguments: {'gameId': gameId, 'user': widget.currentUser},
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
      body: _buildGameList(),
    );
  }

  Widget _buildGameList() {
    if (_games.isEmpty) {
      return Center(
        child: Text('No games found'),
      );
    }

    return ListView.builder(
      itemCount: _games.length,
      itemBuilder: (context, index) {
        var game = Game.fromMap(_games[index]);
        return ListTile(
          title: Text(game.name),
          subtitle: Text(game.description),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => _reviewGame(game.id ?? -1),
          ),
        );
      },
    );
  }
}