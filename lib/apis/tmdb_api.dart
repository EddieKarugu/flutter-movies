import 'dart:convert';
import 'package:http/http.dart' as http;


class TmdbApi{

  static const baseUrl = 'https://api.themoviedb.org/3';
  static const apiKey = '2bfcb4cb7885beaf690ca47f1b202f73';

  Future<dynamic> getMovies () async {
    final url = Uri.parse('$baseUrl/movie/popular?api_key=$apiKey');
    final rensponse = await http.get(url);

    if(rensponse.statusCode == 200){
      final data = jsonDecode(rensponse.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getMovieDetails(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId?api_key=$apiKey');
    final rensponse = await http.get(url);

    if(rensponse.statusCode == 200){
      final data = jsonDecode(rensponse.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> searchMovies(String query) async {
    final url = Uri.parse('$baseUrl/search/movie?api_key=$apiKey&query=$query');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getMovieCredits(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/credits?api_key=$apiKey');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getMovieReviews(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/reviews?api_key=$apiKey');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getMovieRecommendations(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/recommendations?api_key=$apiKey');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getMovieVideos(int movieId) async {
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      return data;
    }
    else{
      throw Exception('Failed to load movies');
    }
  }

  Future<dynamic> getMovieTrailer(int movieId) async{
    final url = Uri.parse('$baseUrl/movie/$movieId/videos?api_key=$apiKey');
    final response = await http.get(url);

    if(response.statusCode == 200){
      final data = jsonDecode(response.body);
      final trailer = data['results'].firstWhere((video) => video['type'] == 'Trailer', orElse: () => null);
      return trailer;
    }
    else{
      throw Exception('Failed to load Trailer');
    }
  }
}
