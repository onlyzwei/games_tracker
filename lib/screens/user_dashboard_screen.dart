// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api, unused_import

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/screens/add_game_screen.dart';
import 'package:games_tracker/screens/remove_game_screen.dart';
import 'package:games_tracker/screens/review_game_screen.dart';
import 'package:games_tracker/main.dart'; // Certifique-se de importar o arquivo onde o MyApp está definido.

class UserDashboardScreen extends StatefulWidget {
  static const routeName = '/user-dashboard';
  final User currentUser;

  const UserDashboardScreen({super.key, required this.currentUser});

  @override
  _UserDashboardScreenState createState() => _UserDashboardScreenState();
}

class _UserDashboardScreenState extends State<UserDashboardScreen> with RouteAware {
  final GameController _gameController = GameController();
  List<GameWithScore> _gamesWithScores = [];

  @override
  void initState() {
    super.initState();
    _loadGamesWithScores();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ModalRoute? route = ModalRoute.of(context);
    if (route is PageRoute) {
      MyApp.routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    MyApp.routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPopNext() {
    // Chama a função quando retornando para esta tela
    _loadGamesWithScores();
  }

  Future<void> _loadGamesWithScores() async {
    var games = await _gameController.getGames();
    List<GameWithScore> gamesWithScores = [];

    for (var gameMap in games) {
      var game = Game.fromMap(gameMap);
      var avgScore = await _gameController.getAverageScore(game.id ?? -1);
      gamesWithScores.add(GameWithScore(game: game, averageScore: avgScore));
    }

    setState(() {
      _gamesWithScores = gamesWithScores;
    });
  }

  void _addGame() {
    Navigator.pushNamed(
      context,
      AddGameScreen.routeName,
      arguments: {'user': widget.currentUser},
    ).then((_) => _loadGamesWithScores()); // Recarrega a lista de jogos após adicionar um novo
  }

  void _removeGame() {
    Navigator.pushNamed(
      context,
      RemoveGameScreen.routeName,
      arguments: {'user': widget.currentUser},
    ).then((_) => _loadGamesWithScores()); // Recarrega a lista de jogos após remover um jogo
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
    if (_gamesWithScores.isEmpty) {
      return Center(
        child: Text('No games found'),
      );
    }

    return ListView.builder(
      itemCount: _gamesWithScores.length,
      itemBuilder: (context, index) {
        var gameWithScore = _gamesWithScores[index];
        var game = gameWithScore.game;
        var averageScore = gameWithScore.averageScore?.toStringAsFixed(2) ?? 'No reviews';

        return ListTile(
          title: Text(game.name),
          subtitle: Text('Average Score: $averageScore'),
          trailing: IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () => _reviewGame(game.id ?? -1),
          ),
        );
      },
    );
  }
}

class GameWithScore {
  final Game game;
  final double? averageScore;

  GameWithScore({required this.game, required this.averageScore});
}
