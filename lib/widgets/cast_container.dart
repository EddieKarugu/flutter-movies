import 'package:flutter/material.dart';

class CastContainer extends StatelessWidget {
  final Map<String, dynamic> character;
  const CastContainer({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    final profilePath = character['profile_path'];
    final imageUrl = profilePath != null
        ? 'https://image.tmdb.org/t/p/w200$profilePath'
        : null;

    return SizedBox(
      width: 80,
      child: Column(
        children: [
          ClipOval(
            child: imageUrl != null
                ? Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.person, size: 70),
            )
                : const Icon(Icons.person, size: 70),
          ),
          const SizedBox(height: 4),
          Text(
            character['name'] ?? 'Unknown',
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            character['character'] ?? '',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}