import 'package:flutter/material.dart';
import 'package:phanmovies/widgets/input_field_widget.dart';
import 'package:phanmovies/widgets/movie_container.dart';

import '../apis/tmdb_api.dart';
import 'movie_details.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width <= 400;
    final isTabletScreen = size.width > 400 && size.width <= 900;
    final isWidescreen = size.width > 900;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            FittedBox(
              child: ShaderMask(
                shaderCallback: (Rect bounds) {
                  return const LinearGradient(
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
            InputFieldWidget(
              hint: 'search',
              iconData: Icons.search,
              isPassword: false,
              controller: _searchController,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FutureBuilder(
                future: TmdbApi().getMovies(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: Color(0xff0000ff),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else {
                    final movies = snapshot.data['results'];

                    return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isSmallScreen ? 2 : isTabletScreen ? 4 : 7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: isSmallScreen? 1: isTabletScreen? .8 : .9

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
          ],
        ),
      ),
    );
  }
}
