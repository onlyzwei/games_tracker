// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace
import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/user_controller.dart';
import 'package:games_tracker/models/user.dart';
class AdmScreen extends StatefulWidget {
  static const routeName = '/adm';

  const AdmScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdmScreenState createState() => _AdmScreenState();
}

class _AdmScreenState extends State<AdmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final UserController _userController = UserController();
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    var users = await _userController.getUsers();
    setState(() {
      _users = users; // Atualiza a lista com os usuários obtidos do banco de dados
    });
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
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

  Future<void> _deleteUser(int id) async {
    await _userController.deleteUser(id);
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Management'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _register,
                    child: Text('Add User'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Espaçamento entre o formulário e a lista
            Expanded(
              child: Center(
                child: _buildUserList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserList() {
    return ListView.builder(
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
}


