import 'package:flutter/material.dart';
import 'package:phanmovies/pages/videasy_movie_playing_page.dart';
import 'package:phanmovies/widgets/review_container.dart';
import '../apis/tmdb_api.dart';
import '../widgets/cast_container.dart';
import '../widgets/movie_container.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class MovieDetails extends StatefulWidget {
  final Map<String, dynamic> movie;
  final String mediaType; // 'movie' or 'tv'
  const MovieDetails({
    super.key,
    required this.movie,
    required this.mediaType,
  });

  @override
  State<MovieDetails> createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  final TmdbApi _api = TmdbApi();
  late Future<dynamic> _trailerFuture;
  late Future<Map<String, dynamic>> _creditsFuture;
  late Future<Map<String, dynamic>> _reviewsFuture;
  late Future<Map<String, dynamic>> _recommendationsFuture;

  // Tab selection: 0 = Recommendations, 1 = Cast & Reviews
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _trailerFuture = _getTrailer();
    _creditsFuture = _getCredits();
    _reviewsFuture = _getReviews();
    _recommendationsFuture = _getRecommendations();
  }

  Future<dynamic> _getTrailer() {
    if (widget.mediaType == 'tv') {
      return _api.getTvTrailer(widget.movie['id']);
    } else {
      return _api.getMovieTrailer(widget.movie['id']);
    }
  }

  Future<Map<String, dynamic>> _getCredits() {
    if (widget.mediaType == 'tv') {
      return _api.getTvCredits(widget.movie['id']);
    } else {
      return _api.getMovieCredits(widget.movie['id']);
    }
  }

  Future<Map<String, dynamic>> _getReviews() {
    if (widget.mediaType == 'tv') {
      return _api.getTvReviews(widget.movie['id']);
    } else {
      return _api.getMovieReviews(widget.movie['id']);
    }
  }

  Future<Map<String, dynamic>> _getRecommendations() {
    if (widget.mediaType == 'tv') {
      return _api.getTvRecommendations(widget.movie['id']);
    } else {
      return _api.getMovieRecommendations(widget.movie['id']);
    }
  }

  String get _title {
    if (widget.mediaType == 'tv') {
      return widget.movie['name'] ?? 'No title';
    } else {
      return widget.movie['title'] ?? 'No title';
    }
  }

  String get _releaseDate {
    if (widget.mediaType == 'tv') {
      return widget.movie['first_air_date'] ?? 'Unknown date';
    } else {
      return widget.movie['release_date'] ?? 'Unknown date';
    }
  }

  double get _rating {
    final rating = widget.movie['vote_average'];
    if (rating is num) return rating.toDouble();
    return 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 400;
    final isTabletScreen = size.width > 400 && size.width <= 900;
    final isWidescreen = size.width > 900;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -------------------- TRAILER --------------------
              Center(
                child: FutureBuilder(
                  future: _trailerFuture,
                  builder: (context, snapshot) {
                    Widget playerWidget;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      playerWidget = const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasData && snapshot.data != null) {
                      final trailerData = snapshot.data;
                      final videoKey = trailerData['key'] as String?;
                      if (videoKey != null && videoKey.isNotEmpty) {
                        final controller = YoutubePlayerController(
                          initialVideoId:
                          YoutubePlayer.convertUrlToId(videoKey) ?? videoKey,
                          flags: const YoutubePlayerFlags(
                            autoPlay: true,
                            mute: false,
                          ),
                        );
                        playerWidget = YoutubePlayer(controller: controller);
                      } else {
                        playerWidget = const Center(child: Text('No trailer available'));
                      }
                    } else {
                      playerWidget = const Center(child: Text('No trailer available'));
                    }

                    return ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: isWidescreen ? 600 : size.width,
                      ),
                      child: SizedBox(
                        width: size.width,
                        height: isWidescreen ? 450 : 200,
                        child: playerWidget,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 15),

              // Title, rating, release date, overview
              Text(
                _title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.star, size: 16, color: Colors.amber),
                  const SizedBox(width: 5),
                  Text(_rating.toStringAsFixed(1)),
                ],
              ),
              Text('Release Date: $_releaseDate'),
              const SizedBox(height: 8),
              Text(widget.movie['overview'] ?? 'No description available'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final playerTitle = widget.mediaType == 'tv'
                          ? (widget.movie['name'] ?? 'TV Show')
                          : (widget.movie['title'] ?? 'Movie');
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => VideasyMoviePlayerPage(
                            movieId: widget.movie['id'],
                            movieTitle: playerTitle,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      foregroundColor: Theme.of(context).colorScheme.onSurface,
                      overlayColor: Colors.grey,
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child:  Text('Watch Now', style: TextStyle(color: Theme.of(context).colorScheme.surface),),
                  ),
                  CircleAvatar(
                    child: Icon(
                      Icons.download,
                      color: Theme.of(context).colorScheme.surface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // ---------- TAB BUTTONS (Left / Right) ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => setState(() => _selectedTab = 0),
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(200, 50),
                      backgroundColor: _selectedTab == 0
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey.shade800,
                      foregroundColor: _selectedTab == 0 ? Colors.black : Colors.white,
                    ),
                    child: const Text('Recommendations'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () => setState(() => _selectedTab = 1),
                    style: ElevatedButton.styleFrom(
                      maximumSize: Size(200, 50),
                      backgroundColor: _selectedTab == 1
                          ? Theme.of(context).colorScheme.secondary
                          : Colors.grey.shade800,
                      foregroundColor: _selectedTab == 1 ? Colors.black : Colors.white,
                    ),
                    child: const Text('Cast & Reviews'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ---------- DYNAMIC CONTENT (only one visible) ----------
              IndexedStack(
                index: _selectedTab,
                children: [
                  // Tab 0: Recommendations
                  FutureBuilder(
                    future: _recommendationsFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final movies = snapshot.data?['results'] as List? ?? [];
                      if (movies.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('No recommendations'),
                        );
                      }
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isSmallScreen
                              ? 2
                              : isTabletScreen
                              ? 4
                              : 6,
                          mainAxisSpacing: 10,
                          crossAxisSpacing: 10,
                          childAspectRatio: isSmallScreen ? 1 : isTabletScreen ? 0.8 : 0.9,
                        ),
                        itemCount: movies.length,
                        itemBuilder: (context, index) {
                          final recMovie = movies[index];
                          return MovieContainer(
                            movie: recMovie,
                            mediaType: widget.mediaType,
                            ontap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MovieDetails(
                                    movie: recMovie,
                                    mediaType: widget.mediaType,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),

                  // Tab 1: Cast & Reviews
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cast section
                      const Text(
                        'Cast',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder(
                        future: _creditsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final cast = snapshot.data?['cast'] as List? ?? [];
                          if (cast.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No cast information'),
                            );
                          }
                          return SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: cast.length,
                              itemBuilder: (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                child: CastContainer(character: cast[index]),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),

                      // Reviews section
                      const Text(
                        'Reviews',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder(
                        future: _reviewsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          final reviews = snapshot.data?['results'] as List? ?? [];
                          if (reviews.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('No reviews yet'),
                            );
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: reviews.length,
                            itemBuilder: (context, index) =>
                                ReviewContainer(review: reviews[index]),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}