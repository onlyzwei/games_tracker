// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/review_controller.dart';
import 'package:games_tracker/models/user.dart';

class AddReviewScreen extends StatefulWidget {
  static const routeName = '/add-review';
  final int gameId;
  final User currentUser;

  const AddReviewScreen({
    super.key,
    required this.gameId,
    required this.currentUser,
  });

  @override
  _AddReviewScreenState createState() => _AddReviewScreenState();
}

class _AddReviewScreenState extends State<AddReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final _scoreController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final ReviewController _reviewController = ReviewController();

  void _submitReview() async {
    if (_formKey.currentState?.validate() ?? false) {
      await _reviewController.addReview(
        widget.gameId,
        widget.currentUser.id!,
        double.parse(_scoreController.text),
        _descriptionController.text,
        _dateController.text,
      );
      if(mounted){
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Review'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _scoreController,
                decoration: InputDecoration(labelText: 'Score'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a score';
                  }
                  if(double.parse(value)> 10 || double.parse(value) < 0){
                    return 'Please enter a valid score';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a date';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
