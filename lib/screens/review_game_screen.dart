// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/review_controller.dart';
import 'package:games_tracker/models/review.dart';
import 'package:games_tracker/models/user.dart';
import 'package:games_tracker/screens/add_review_screen.dart';

class ReviewGameScreen extends StatefulWidget {
  static const routeName = '/review-game';
  final int gameId;
  final User currentUser;

  const ReviewGameScreen({
    super.key,
    required this.gameId,
    required this.currentUser,
  });

  @override
  _ReviewGameScreenState createState() => _ReviewGameScreenState();
}

class _ReviewGameScreenState extends State<ReviewGameScreen> {
  final ReviewController _reviewController = ReviewController();
  List<Review> _reviews = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
  }

  Future<void> _loadReviews() async {
    var reviews = await _reviewController.getReviewsByGameId(widget.gameId);
    setState(() {
      _reviews = reviews;
    });
  }

  void _addReview() {
    Navigator.pushNamed(
      context,
      AddReviewScreen.routeName,
      arguments: {'gameId': widget.gameId, 'user': widget.currentUser},
    ).then((_) => _loadReviews()); // Recarrega a lista de reviews após adicionar um novo
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Game'),
      ),
      body: Column(
        children: [
          Expanded(child: _buildReviewList()),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _addReview,
              child: Text('Add Review'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewList() {
    if (_reviews.isEmpty) {
      return Center(
        child: Text('No reviews found for this game'),
      );
    }

    return ListView.builder(
      itemCount: _reviews.length,
      itemBuilder: (context, index) {
        var review = _reviews[index];
        return ListTile(
          title: Text(review.description),
          subtitle: Text('Score: ${review.score}, Date: ${review.date}'),
        );
      },
    );
  }
}
