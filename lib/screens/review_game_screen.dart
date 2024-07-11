// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:games_tracker/controllers/review_controller.dart';
import 'package:games_tracker/controllers/game_controller.dart';
import 'package:games_tracker/models/game.dart';
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
  final GameController _gameController = GameController();
  late Future<Game> _game;
  late Future<List<Review>> _reviews;

  @override
  void initState() {
    super.initState();
    _game = _fetchGame();
    _reviews = _fetchReviews();
  }

  Future<Game> _fetchGame() async {
    return _gameController.getGameById(widget.gameId);
  }

  Future<List<Review>> _fetchReviews() async {
    return _reviewController.getReviewsByGameId(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Game'),
      ),
      body: FutureBuilder(
        future: Future.wait([_game, _reviews]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            var game = snapshot.data?[0] as Game;
            var reviews = snapshot.data?[1] as List<Review>;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    game.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text('Description: ${game.description}'),
                  Text('Release Date: ${game.releaseDate}'),
                  SizedBox(height: 20),
                  Text(
                    'Reviews',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review = reviews[index];
                        return ListTile(
                          title: Text('Score: ${review.score}'),
                          subtitle: Text('Description: ${review.description}\nDate: ${review.date}'),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddReviewScreen.routeName,
            arguments: {'gameId': widget.gameId, 'user': widget.currentUser},
          ).then((_) {
            setState(() {
              _reviews = _fetchReviews();
            });
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
