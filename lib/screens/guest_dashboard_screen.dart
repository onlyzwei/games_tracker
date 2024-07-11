// screens/guest_dashboard_screen.dart

// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/screens/review_game_screen.dart';

class GuestDashboardScreen extends StatefulWidget {
  static const routeName = '/guest-dashboard';

  const GuestDashboardScreen({super.key});

  @override
  _GuestDashboardScreenState createState() => _GuestDashboardScreenState();
}

class _GuestDashboardScreenState extends State<GuestDashboardScreen> {
  final GameController _gameController = GameController();
  List<GameWithScore> _gamesWithScores = [];

  @override
  void initState() {
    super.initState();
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

  void _reviewGame(int gameId) {
    Navigator.pushNamed(
      context,
      ReviewGameScreen.routeName,
      arguments: {'gameId': gameId, 'user': null},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Guest Dashboard'),
        centerTitle: true,
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
