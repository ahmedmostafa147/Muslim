import 'package:flutter/material.dart';

class RowDuoIcon extends StatelessWidget {
  const RowDuoIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: () {
            // Handle share action
          },
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: () {
            // Handle copy action
          },
        ),
        IconButton(
          icon: const Icon(Icons.bookmark),
          onPressed: () {
            // Handle bookmark action
          },
        ),
        IconButton(
          icon: const Icon(Icons.favorite),
          onPressed: () {
            // Handle favorite action
          },
        ),
      ],
    );
  }
}