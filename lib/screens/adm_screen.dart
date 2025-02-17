// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/user_controller.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/controllers/genre_controller.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/models/game.dart';
import 'package:games_tracker/models/genre.dart';

class AdmScreen extends StatefulWidget {
  static const routeName = '/adm';

  const AdmScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdmScreenState createState() => _AdmScreenState();
}

class _AdmScreenState extends State<AdmScreen> {
  final _userFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  final _gameFormKey = GlobalKey<FormState>();
  final _gameNameController = TextEditingController();
  final _gameDescriptionController = TextEditingController();
  final _gameReleaseDateController = TextEditingController();
  
  final _genreFormKey = GlobalKey<FormState>();
  final _genreNameController = TextEditingController();

  final UserController _userController = UserController();
  final GameController _gameController = GameController();
  final GenreController _genreController = GenreController();

  List<Map<String, dynamic>> _users = [];
  List<Map<String, dynamic>> _games = [];
  List<Map<String, dynamic>> _genres = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
    _loadGames();
    _loadGenres();
  }

  Future<void> _loadUsers() async {
    var users = await _userController.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _loadGames() async {
    var games = await _gameController.getGames();
    setState(() {
      _games = games;
    });
  }

  Future<void> _loadGenres() async {
    var genres = await _genreController.getGenres();
    setState(() {
      _genres = genres;
    });
  }

  Future<void> _registerUser() async {
    if (_userFormKey.currentState!.validate()) {
      // Verifica se o email já está cadastrado
      bool emailExists = await _userController.checkEmailExists(_emailController.text);
      
      if (emailExists && mounted) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Email Already Exists'),
              content: Text('The email you entered is already registered.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('OK'),
                ),
              ],
            ),
          );
      } else {
        // Se o email não existe, prossegue com o registro
        User newUser = User(
          name: _nameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
        await _userController.insertUser(newUser);
        _nameController.clear();
        _emailController.clear();
        _passwordController.clear();
        _loadUsers();
      }
    }
  }

  Future<void> _registerGame() async {
    if (_gameFormKey.currentState!.validate()) {
      Game newGame = Game(
        userId: 17, // deve ser um id de adm
        name: _gameNameController.text,
        description: _gameDescriptionController.text,
        releaseDate: _gameReleaseDateController.text,
      );
      await _gameController.insertGame(newGame);
      _gameNameController.clear();
      _gameDescriptionController.clear();
      _gameReleaseDateController.clear();
      _loadGames();
    }
  }

  Future<void> _registerGenre() async {
    if (_genreFormKey.currentState!.validate()) {
      Genre newGenre = Genre(
        name: _genreNameController.text,
      );
      await _genreController.insertGenre(newGenre);
      _genreNameController.clear();
      _loadGenres();
    }
  }

  Future<void> _deleteUser(int id) async {
    await _userController.deleteUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Administração'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSectionTitle('Usuário'),
              Form(
                key: _userFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField('Nome', _nameController),
                    _buildTextFormField('Email', _emailController),
                    _buildTextFormField('Senha', _passwordController, obscureText: true),
                    ElevatedButton(
                      onPressed: _registerUser,
                      child: Text('Adicionar Usuário'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Espaçamento entre os formulários
              _buildSectionTitle('Jogo'),
              Form(
                key: _gameFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField('Nome', _gameNameController),
                    _buildTextFormField('Descrição', _gameDescriptionController),
                    _buildTextFormField('Data de Lançamento', _gameReleaseDateController),
                    ElevatedButton(
                      onPressed: _registerGame,
                      child: Text('Adicionar Jogo'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Espaçamento entre os formulários
              _buildSectionTitle('Gênero'),
              Form(
                key: _genreFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildTextFormField('Nome', _genreNameController),
                    ElevatedButton(
                      onPressed: _registerGenre,
                      child: Text('Adicionar Gênero'),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20), // Espaçamento entre o formulário e a lista de usuários
              _buildSectionTitle('Usuários Cadastrados'),
              _buildUserList(),
              SizedBox(height: 20), // Espaçamento entre a lista de usuários e a lista de jogos
              _buildSectionTitle('Jogos Cadastrados'),
              _buildGameList(),
              SizedBox(height: 20), // Espaçamento entre a lista de jogos e a lista de gêneros
              _buildSectionTitle('Gêneros Cadastrados'),
              _buildGenreList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildTextFormField(String labelText, TextEditingController controller, {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      obscureText: obscureText,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, insira $labelText';
        }
        return null;
      },
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _users.length,
      itemBuilder: (context, index) {
        final user = _users[index];
        return ListTile(
          title: Text(user['name']),
          subtitle: Text('ID: ${user['id']}'),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _deleteUser(user['id']),
          ),
        );
      },
    );
  }

  Widget _buildGameList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _games.length,
      itemBuilder: (context, index) {
        final game = _games[index];
        return ListTile(
          title: Text(game['name']),
          subtitle: Text('ID: ${game['id']}'),
        );
      },
    );
  }

  Widget _buildGenreList() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _genres.length,
      itemBuilder: (context, index) {
        final genre = _genres[index];
        return ListTile(
          title: Text(genre['name']),
          subtitle: Text('ID: ${genre['id']}'),
        );
      },
    );
  }
}
