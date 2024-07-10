// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/models/user.dart';

class RemoveGameScreen extends StatefulWidget {
  static const routeName = '/remove-game';
  final User currentUser; // Usuário atual que está logado

  const RemoveGameScreen({super.key, required this.currentUser});

  @override
  _RemoveGameScreenState createState() => _RemoveGameScreenState();
}

class _RemoveGameScreenState extends State<RemoveGameScreen> {
  final GameController _gameController = GameController();
  List<Game> _games = []; // Lista de jogos a serem exibidos

  @override
  void initState() {
    super.initState();
    _loadGames();
  }

  Future<void> _loadGames() async {
    var games = await _gameController.getGames(); // Método para carregar os jogos
    setState(() {
      _games = games.map((gameMap) => Game.fromMap(gameMap)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Remover Jogo'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: _games.length,
        itemBuilder: (context, index) {
          final game = _games[index];
          return ListTile(
            title: Text(game.name),
            subtitle: Text('Descrição: ${game.description}'),
            onTap: () => _deleteGame(game.id), // Ao tocar no jogo, ele será removido
          );
        },
      ),
    );
  }

  Future<void> _deleteGame(int? gameId) async {
    await _gameController.deleteGame(gameId); // Método para excluir o jogo
    _loadGames(); // Recarrega a lista de jogos após a exclusão
  }
}
