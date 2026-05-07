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
            'https://image.tmdb.org/t/p/w500${widget.movie['poster_path']}',
            scale: 1.0,
          ),
        ),
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            widget.movie['title'],
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Theme.of(context).colorScheme.onSurface
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.movie['release_date']),
              Row(
                children: [
                  Icon(Icons.star, size: 20, color: Colors.amber,),
                  Text(widget.movie['vote_average'].toStringAsFixed(1)),
                ],
              ),
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
