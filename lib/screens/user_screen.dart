// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/user_controller.dart';
import 'package:games_tracker/models/user.dart';

class UserScreen extends StatefulWidget {
  static const routeName = '/user';
  const UserScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
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
    List<Map<String, dynamic>> users = await _userController.getUsers();
    setState(() {
      _users = users;
    });
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gerenciamento de usuários'),
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
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _addUser,
                    child: Text('Add User'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: _users.isEmpty
                  ? Center(child: Text('No users found'))
                  : ListView.builder(
                      itemCount: _users.length,
                      itemBuilder: (context, index) {
                        var user = _users[index];
                        return ListTile(
                          title: Text(user['name']),
                          subtitle: Text('ID: ${user['id']}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
