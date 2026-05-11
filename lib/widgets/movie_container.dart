import 'package:flutter/material.dart';
import 'package:phanmovies/pages/videasy_movie_playing_page.dart';

class MovieContainer extends StatefulWidget {
  final Map<String, dynamic> movie;
  final VoidCallback? ontap;
  final String mediaType; // 'movie' or 'tv'
  const MovieContainer({
    super.key,
    required this.movie,
    this.ontap,
    required this.mediaType,
  });

  @override
  State<MovieContainer> createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  String get _title {
    if (widget.mediaType == 'tv') {
      return widget.movie['name'] ?? 'No title';
    } else {
      return widget.movie['title'] ?? 'No title';
    }
  }

  String get _releaseDate {
    if (widget.mediaType == 'tv') {
      return widget.movie['first_air_date'] ?? 'Unknown';
    } else {
      return widget.movie['release_date'] ?? 'Unknown';
    }
  }

  String get _overview {
    return widget.movie['overview'] ?? 'No description';
  }

  double get _rating {
    final rating = widget.movie['vote_average'];
    if (rating is num) return rating.toDouble();
    return 0.0;
  }

  String? get _posterPath {
    final path = widget.movie['poster_path'];
    return path != null ? 'https://image.tmdb.org/t/p/w500$path' : null;
  }

  @override
  Widget build(BuildContext context) {
    // Build the background decoration (either image or fallback gradient)
    final BoxDecoration decoration = BoxDecoration(
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: Theme.of(context).colorScheme.secondary),
      image: _posterPath != null
          ? DecorationImage(
        fit: BoxFit.cover,
        image: NetworkImage(_posterPath!),
      )
          : null,
    );

    final Widget background = _posterPath == null
        ? Container(
      padding: const EdgeInsets.all(5),
      decoration: decoration.copyWith(
        gradient: const LinearGradient(
          colors: [Colors.grey, Colors.black26],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.image_not_supported, size: 40, color: Colors.white70),
      ),
    )
        : Container(
      padding: const EdgeInsets.all(5),
        decoration: decoration);

    return Material(
      color: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            background,
            InkWell(
              onTap: widget.ontap,
              splashColor: Theme.of(context).colorScheme.tertiary,
              hoverColor: Colors.grey,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      _title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Theme.of(context).colorScheme.onSurface,
                        shadows: const [Shadow(offset: Offset(1, 1), blurRadius: 3)],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _releaseDate,
                          style: const TextStyle(shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2)]),
                        ),
                        Row(
                          children: [
                            Icon(Icons.star, size: 20, color: Colors.amber),
                            Text(_rating.toStringAsFixed(1)),
                          ],
                        ),
                      ],
                    ),
                    Text(
                      _overview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(shadows: [Shadow(offset: Offset(1, 1), blurRadius: 2)]),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}