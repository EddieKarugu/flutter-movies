import 'package:flutter/material.dart';

class ReviewContainer extends StatelessWidget {
  final Map<String, dynamic> review;
  const ReviewContainer({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final author = review['author'] ?? 'Anonymous';
    final content = review['content'] ?? 'No content';
    final rating = review['author_details']?['rating'] as double?;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  child: Icon(Icons.person, size: 18),
                ),
                const SizedBox(width: 8),
                Text(
                  author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                if (rating != null) ...[
                  const SizedBox(width: 12),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      Text(' $rating'),
                    ],
                  ),
                ],
              ],
            ),
            const SizedBox(height: 8),
            Text(content, style: TextStyle(fontSize: 12),),
          ],
        ),
      ),
    );
  }
}