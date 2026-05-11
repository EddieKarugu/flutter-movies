import 'dart:convert';
import 'package:http/http.dart' as http;

class TmdbApi {
  static const baseUrl = 'https://api.themoviedb.org/3';
  static const apiKey = '2bfcb4cb7885beaf690ca47f1b202f73';

  // ------------------------------------------------------------------
  // Existing methods (kept as is)
  // ------------------------------------------------------------------
  Future<Map<String, dynamic>> getMovies({int page = 1}) async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to load movies');
    }
  }

  Future<Map<String, dynamic>> getMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie details');
    }
  }

  Future<Map<String, dynamic>> searchMovies(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search movies');
    }
  }

  Future<Map<String, dynamic>> getMovieCredits(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie credits');
    }
  }

  Future<Map<String, dynamic>> getMovieReviews(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/reviews?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie reviews');
    }
  }

  Future<Map<String, dynamic>> getMovieRecommendations(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/recommendations?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie recommendations');
    }
  }

  Future<Map<String, dynamic>> getMovieVideos(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load movie videos');
    }
  }

  Future<dynamic> getMovieTrailer(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trailer = data['results'].firstWhere(
            (video) => video['type'] == 'Trailer',
        orElse: () => null,
      );
      return trailer;
    } else {
      throw Exception('Failed to load trailer');
    }
  }

  // ------------------------------------------------------------------
  // New methods: Trending, TV, Now Playing, Upcoming, Anime
  // ------------------------------------------------------------------
  Future<Map<String, dynamic>> getTrending({
    String mediaType = 'all',
    String timeWindow = 'day',
    int page = 1,
  }) async {
    final url = Uri.parse(
      '$baseUrl/trending/$mediaType/$timeWindow?api_key=$apiKey&page=$page',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load trending');
    }
  }

  Future<Map<String, dynamic>> getPopularTV({int page = 1}) async {
    final url = Uri.parse('$baseUrl/tv/popular?api_key=$apiKey&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load popular TV shows');
    }
  }

  Future<Map<String, dynamic>> getTopRatedTV({int page = 1}) async {
    final url = Uri.parse('$baseUrl/tv/top_rated?api_key=$apiKey&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top rated TV shows');
    }
  }

  Future<Map<String, dynamic>> getNowPlayingMovies({int page = 1}) async {
    final url = Uri.parse('$baseUrl/movie/now_playing?api_key=$apiKey&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load now playing movies');
    }
  }

  Future<Map<String, dynamic>> getUpcomingMovies({int page = 1}) async {
    final url = Uri.parse('$baseUrl/movie/upcoming?api_key=$apiKey&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load upcoming movies');
    }
  }

  Future<Map<String, dynamic>> getTopRatedMovies({int page = 1}) async {
    final url = Uri.parse('$baseUrl/movie/top_rated?api_key=$apiKey&page=$page');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load top rated movies');
    }
  }

  Future<Map<String, dynamic>> getAnime({
    String type = 'movie',
    int page = 1,
  }) async {
    final String endpoint = type == 'movie' ? 'discover/movie' : 'discover/tv';
    final url = Uri.parse(
      '$baseUrl/$endpoint?api_key=$apiKey&with_genres=16&page=$page&sort_by=popularity.desc',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load anime');
    }
  }

  // ------------------------------------------------------------------
  // TV show specific methods (for details, credits, reviews, trailers)
  // ------------------------------------------------------------------
  Future<Map<String, dynamic>> getTvDetails(int tvId) async {
    final url = Uri.parse('$baseUrl/tv/$tvId?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load TV details');
    }
  }

  Future<Map<String, dynamic>> getTvCredits(int tvId) async {
    final url = Uri.parse('$baseUrl/tv/$tvId/credits?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load TV credits');
    }
  }

  Future<Map<String, dynamic>> getTvReviews(int tvId) async {
    final url = Uri.parse('$baseUrl/tv/$tvId/reviews?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load TV reviews');
    }
  }

  Future<Map<String, dynamic>> getTvRecommendations(int tvId) async {
    final url = Uri.parse('$baseUrl/tv/$tvId/recommendations?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load TV recommendations');
    }
  }

  Future<dynamic> getTvTrailer(int tvId) async {
    final url = Uri.parse('$baseUrl/tv/$tvId/videos?api_key=$apiKey');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final trailer = data['results'].firstWhere(
            (video) => video['type'] == 'Trailer',
        orElse: () => null,
      );
      return trailer;
    } else {
      throw Exception('Failed to load TV trailer');
    }
  }
}