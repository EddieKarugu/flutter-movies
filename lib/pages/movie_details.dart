import 'package:flutter/material.dart';
import 'package:phanmovies/widgets/review_container.dart';
import '../apis/tmdb_api.dart';
import '../widgets/cast_container.dart';
import '../widgets/movie_container.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetails extends StatefulWidget {
  final Map<String, dynamic> movie;
  const MovieDetails({super.key, required this.movie});

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  YoutubePlayerController? _controller;
  late Future<dynamic> _trailer;

  @override
  void initState() {
    super.initState();
    _trailer = TmdbApi().getMovieTrailer(widget.movie['id']);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 400;
    final isTabletScreen = size.width > 400 && size.width <= 900;
    final isWidescreen = size.width > 900;

    return FutureBuilder(
      future: TmdbApi().getMovieTrailer(widget.movie['id']),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          final trailerData = snapshot.data;

          _controller = YoutubePlayerController(
            initialVideoId: YoutubePlayer.convertUrlToId(trailerData['key']) ?? trailerData['key'],
            flags: const YoutubePlayerFlags(autoPlay: true, mute: false),
          );
          return _buildMainScaffold(
            context,
            topWidget: SizedBox(
              width: size.width,
              height: isWidescreen? 450: 200,
              child: YoutubePlayer(
                controller: _controller!,
                showVideoProgressIndicator: true,
              ),
            ),
          );
        } else {
          return _buildMainScaffold(
            context,
            topWidget: SizedBox(height: 200, child: Image.network('')),
          );
        }
      },
    );
  }

  Widget _buildMainScaffold(BuildContext context, {required Widget topWidget}) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 400;
    final isTabletScreen = size.width > 400 && size.width < 900;
    final isWidescreen = size.width >= 900;

    return Scaffold(
      body: SingleChildScrollView(
        primary: true,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWidescreen ? 600 : size.width,
                ),
                child: topWidget,
              ),

              const SizedBox(height: 10),
              Text(
                widget.movie['title'],
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Correctly formatting the rating
              Text(
                "Rating: ${((widget.movie['vote_average'] ?? 0.0) as num).toStringAsFixed(1)}",
              ),

              Text(widget.movie['overview'], softWrap: true),
              Text(widget.movie['release_date']),

              const SizedBox(height: 20),
              const Text('Cast', style: TextStyle(fontWeight: FontWeight.bold)),

              // CAST SECTION
              SizedBox(
                height: 120,
                child: FutureBuilder(
                  future: TmdbApi().getMovieCredits(widget.movie['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final cast = snapshot.data?['cast'] ?? [];
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: cast.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: CastContainer(character: cast[index]),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Reviews',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // REVIEWS SECTION
              SizedBox(
                height: 200, // Adjusted height
                child: FutureBuilder(
                  future: TmdbApi().getMovieReviews(widget.movie['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final reviews = snapshot.data?['results'] ?? [];
                    return ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) =>
                          ReviewContainer(review: reviews[index]),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'You might also like',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              // RECOMMENDATIONS SECTION
              SizedBox(
                height: 400,
                child: FutureBuilder(
                  future: TmdbApi().getMovieRecommendations(widget.movie['id']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final movies = snapshot.data?['results'] ?? [];
                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isSmallScreen
                            ? 2
                            : isTabletScreen
                            ? 4
                            : 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: isSmallScreen ? 1 : 0.8,
                      ),
                      itemCount: movies.length,
                      itemBuilder: (context, index) => InkWell(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                MovieDetails(movie: movies[index]),
                          ),
                        ),
                        child: MovieContainer(movie: movies[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
