import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';

class CharacterWidget extends StatelessWidget {
  final String name;
  const CharacterWidget({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    final theme = Theme.of(context);

    IconData icon;
    if (appState.favorites.contains(name)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          color: theme.colorScheme.onPrimary,
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 18.0),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            appState.toggleFavorite(name);
          },
          icon: Icon(icon),
          label: const Text('Like'),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () {},
          child: const Text('More'),
        ),
      ],
    );
  }
}
