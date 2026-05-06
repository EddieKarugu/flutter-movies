import 'package:flutter/material.dart';

class MovieContainer extends StatefulWidget {
  final Map<String, dynamic> movie;
  const MovieContainer({super.key, required this.movie});

  @override
  State<MovieContainer> createState() => _MovieContainerState();
}

class _MovieContainerState extends State<MovieContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
            'https://image.tmdb.org/t/p/original/${widget.movie['poster_path']}',
            scale: 1.0,
          ),
        ),
        border: Border.all(color: Color(0xff0000ff)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FittedBox(
            child: Text(
              widget.movie['title'],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 28
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Row(
            children: [
              Text(widget.movie['release_date']),
              Text(widget.movie['vote_average'].toString()),
            ],
          ),
          Text(
            widget.movie['overview'],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
