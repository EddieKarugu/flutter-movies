import 'package:flutter/material.dart';
import '../apis/tmdb_api.dart';
import '../widgets/input_field_widget.dart';
import '../widgets/movie_container.dart';
import 'movie_details.dart';

enum MovieCategory {
  popularMovies,
  trending,
  popularTv,
  topRatedMovies,
  nowPlaying,
  upcoming,
  anime,
}

extension CategoryLabel on MovieCategory {
  String get label {
    switch (this) {
      case MovieCategory.popularMovies:
        return 'Popular Movies';
      case MovieCategory.trending:
        return 'Trending';
      case MovieCategory.popularTv:
        return 'Popular TV';
      case MovieCategory.topRatedMovies:
        return 'Top Rated';
      case MovieCategory.nowPlaying:
        return 'Now Playing';
      case MovieCategory.upcoming:
        return 'Upcoming';
      case MovieCategory.anime:
        return 'Anime';
    }
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TmdbApi _tmdbApi = TmdbApi();
  List<dynamic> _movies = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();
  late TextEditingController _searchController;
  MovieCategory _selectedCategory = MovieCategory.popularMovies;

  @override
  void initState() {
    super.initState();
    _loadMovies();
    _scrollController.addListener(_onScroll);
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoading && _hasMore) {
        _loadMovies();
      }
    }
  }

  void _changeCategory(MovieCategory newCategory) {
    if (_selectedCategory == newCategory) return;
    setState(() {
      _selectedCategory = newCategory;
      _movies.clear();
      _currentPage = 1;
      _hasMore = true;
      _isLoading = false;
    });
    _loadMovies();
  }

  String _getMediaTypeForCurrentCategory() {
    // Only 'popularTv' should be treated as TV; all others are movies
    if (_selectedCategory == MovieCategory.popularTv) return 'tv';
    return 'movie';
  }

  Future<void> _loadMovies() async {
    if (_isLoading || !_hasMore) return;
    setState(() => _isLoading = true);

    try {
      Map<String, dynamic> data;
      switch (_selectedCategory) {
        case MovieCategory.popularMovies:
          data = await _tmdbApi.getMovies(page: _currentPage);
          break;
        case MovieCategory.trending:
          data = await _tmdbApi.getTrending(
            mediaType: 'movie',
            timeWindow: 'week',
            page: _currentPage,
          );
          break;
        case MovieCategory.popularTv:
          data = await _tmdbApi.getPopularTV(page: _currentPage);
          break;
        case MovieCategory.topRatedMovies:
          data = await _tmdbApi.getTopRatedMovies(page: _currentPage);
          break;
        case MovieCategory.nowPlaying:
          data = await _tmdbApi.getNowPlayingMovies(page: _currentPage);
          break;
        case MovieCategory.upcoming:
          data = await _tmdbApi.getUpcomingMovies(page: _currentPage);
          break;
        case MovieCategory.anime:
          data = await _tmdbApi.getAnime(type: 'movie', page: _currentPage);
          break;
      }

      final newMovies = data['results'] as List<dynamic>;
      final totalPages = data['total_pages'] as int;

      setState(() {
        _movies.addAll(newMovies);
        _currentPage++;
        _hasMore = _currentPage <= totalPages;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSmallScreen = MediaQuery.of(context).size.width < 600;
    bool isTabletScreen = MediaQuery.of(context).size.width >= 600 &&
        MediaQuery.of(context).size.width < 1200;

    return Scaffold(
      body: Column(
        children: [
           FittedBox(
            child: ShaderMask(
              shaderCallback: (Rect bounds) {
                return LinearGradient(
                  colors: [Color(0xff0000ff), Color(0xffff0000)],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                ).createShader(bounds);
              },
              blendMode: BlendMode.srcIn,
              child: Text(
                'PhanMovies',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Horizontal ActionChips
            SizedBox(
              height: 50,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: MovieCategory.values.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (context, index) {
                  final category = MovieCategory.values[index];
                  return ActionChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: Text(category.label),
                    onPressed: () => _changeCategory(category),
                    backgroundColor: _selectedCategory == category
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey.shade300,
                    labelStyle: TextStyle(
                      color: _selectedCategory == category
                          ? Colors.white
                          : Colors.black87,
                    ),
                  );
                },
              ),
            ),

          const SizedBox(height: 20),

          InputFieldWidget(
            hint: 'search',
            iconData: Icons.search,
            isPassword: false,
            controller: _searchController,
          ),
          const SizedBox(height: 20),

          Expanded(
            child: _movies.isEmpty && _isLoading
                ? Center(child: CircularProgressIndicator(color: const Color(0xff0000ff)))
                : GridView.builder(
              controller: _scrollController,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                isSmallScreen ? 2 : isTabletScreen ? 4 : 7,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio:
                isSmallScreen ? 1 : isTabletScreen ? 0.8 : 0.9,
              ),
              itemCount: _movies.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _movies.length && _hasMore) {
                  return const Center(child: CircularProgressIndicator());
                }
                final movie = _movies[index];
                final mediaType = _getMediaTypeForCurrentCategory();
                return MovieContainer(
                  mediaType: _getMediaTypeForCurrentCategory(),
                  movie: movie,
                  ontap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MovieDetails(
                          movie: movie,
                          mediaType: mediaType,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}