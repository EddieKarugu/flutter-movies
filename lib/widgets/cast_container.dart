import 'package:flutter/material.dart';

class CastContainer extends StatelessWidget {
  final Map<String, dynamic> character;
  const CastContainer({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
      SizedBox(
        height: 70,
          child: Image.network('https://image.tmdb.org/t/p/w500${character['profile_path']}')),
        Text(character['name']),
        Text(character['character']),
      ],
    );
  }
}
