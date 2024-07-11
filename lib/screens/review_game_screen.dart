// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

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
  final User? currentUser;

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
                        return _buildReviewTile(review);
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
          if (widget.currentUser != null) {
            Navigator.pushNamed(
              context,
              AddReviewScreen.routeName,
              arguments: {'gameId': widget.gameId, 'user': widget.currentUser},
            ).then((_) {
              setState(() {
                _reviews = _fetchReviews();
              });
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Usuário deve estar cadastrado')),
            );
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildReviewTile(Review review) {
    bool isCurrentUserReviewOwner = review.userId == widget.currentUser?.id;

    return ListTile(
      title: Text('Score: ${review.score}'),
      subtitle: Text('Description: ${review.description}\nDate: ${review.date}'),
      trailing: isCurrentUserReviewOwner
          ? IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteReview(review.id ?? -1); // Implementar a função de exclusão aqui
              },
            )
          : null,
    );
  }

  void _deleteReview(int reviewId) async {
    int deleted = await _reviewController.deleteReview(reviewId);
    if (deleted == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Review excluída com sucesso')),
      );
      setState(() {
        _reviews = _fetchReviews(); // Atualiza a lista de reviews após exclusão
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao excluir a review')),
      );
    }
  }
}
