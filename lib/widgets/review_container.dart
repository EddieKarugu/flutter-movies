import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {
  final Map<String, dynamic> review;
  const ReviewContainer({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(review['author']),
          Text('Rating: ${review['author_details']['rating']}'),
        ],
      ),
      subtitle: Text(review['content'], maxLines: 2, overflow: TextOverflow.ellipsis,),
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(
          'https://image.tmdb.org/t/p/original/${review['author_details']['avatar_path']}',
        ),
      ),
    );
  }
}
