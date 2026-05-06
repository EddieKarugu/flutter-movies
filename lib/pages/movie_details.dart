import 'package:flutter/material.dart';
import 'package:phanmovies/widgets/review_container.dart';

import '../apis/tmdb_api.dart';
import '../widgets/cast_container.dart';
import '../widgets/movie_container.dart';

class MovieDetails extends StatefulWidget {
  final Map<String, dynamic> movie;
  const MovieDetails({super.key, required this.movie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              FittedBox(
                child: Text(
                  widget.movie['title'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(
                height: 200,
                child: Image.network(
                  'https://image.tmdb.org/t/p/original/${widget.movie['poster_path']}',
                ),
              ),
              Text(widget.movie['vote_average'].toString()),
              Text(widget.movie['overview'], softWrap: true),
              Text(widget.movie['release_date']),
              const SizedBox(height: 20),
              Text('Cast', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 120,
                child: FutureBuilder(
                  future: TmdbApi().getMovieCredits(widget.movie['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == 'waiting') {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final cast = snapshot.data['cast'];
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: CastContainer(character: cast[index]),
                          );
                        },
                        itemCount: cast.length,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text('Reviews', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(
                height: 150,
                child: FutureBuilder(
                  future: TmdbApi().getMovieReviews(widget.movie['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == 'waiting') {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final reviews = snapshot.data['results'];
                      return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10.0,
                            ),
                            child: ReviewContainer(review: reviews[index]),
                          );
                        },
                        itemCount: reviews.length,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'You might also like',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 400,
                child: FutureBuilder(
                  future: TmdbApi().getMovieRecommendations(widget.movie['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == 'waiting') {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      final movies = snapshot.data['results'];
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.2

                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                              splashColor: Color(0xff0000ff),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MovieDetails(movie: movies[index])));
                              },
                              child: MovieContainer(movie: movies[index]));
                        },
                        itemCount: movies.length,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
