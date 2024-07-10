// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/models/user.dart';

class AddGameScreen extends StatefulWidget {
  static const routeName = '/add-game';
  final User currentUser;

  const AddGameScreen({super.key, required this.currentUser});

  @override
  _AddGameScreenState createState() => _AddGameScreenState();
}

class _AddGameScreenState extends State<AddGameScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _releaseDateController = TextEditingController();

  final GameController _gameController = GameController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adicionar Jogo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField('Nome do Jogo', _nameController),
              _buildTextFormField('Descrição do Jogo', _descriptionController),
              _buildTextFormField('Data de Lançamento', _releaseDateController),
              ElevatedButton(
                onPressed: _registerGame,
                child: Text('Adicionar Jogo'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField(String labelText, TextEditingController controller) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $labelText';
        }
        return null;
      },
    );
  }

  Future<void> _registerGame() async {
    if (_formKey.currentState!.validate()) {
      Game newGame = Game(
        userId: widget.currentUser.id ?? -1, // Usuário atual que está logado
        name: _nameController.text,
        description: _descriptionController.text,
        releaseDate: _releaseDateController.text,
      );
      await _gameController.insertGame(newGame);
      if(mounted){
        Navigator.pop(context);
      } // Volta para a tela anterior após adicionar o jogo
    }
  }
}
