import 'package:flutter/material.dart';
import 'character_fetcher.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Star Wars Characters',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          useMaterial3: true,
        ),
        home: const CharacterListScreen(title: 'Star Wars Characters'),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = "";
  var favorites = <String>[];

  void toggleFavorite(String currentName) {
    if (favorites.contains(currentName)) {
      favorites.remove(currentName);
      print("removed favorite");
    } else {
      favorites.add(currentName);
      print("added favorite");
    }
    notifyListeners();
  }
}

class CharacterListScreen extends StatefulWidget {
  const CharacterListScreen({super.key, required this.title});

  final String title;

  @override
  State<CharacterListScreen> createState() => _CharacterListScreenState();
}

class _CharacterListScreenState extends State<CharacterListScreen> {
  final CharacterFetcher fetcher = CharacterFetcher();
  Future<List<String>>? _futureCharacterNames;

  @override
  void initState() {
    super.initState();
    _futureCharacterNames = fetcher.fetchCharacterNames();
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
          child: FutureBuilder<List<String>>(
              future: _futureCharacterNames,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final characterNames = snapshot.data!;
                  return ListView.builder(
                    itemCount: characterNames.length,
                    itemBuilder: (context, index) {
                      return CharacterWidget(
                        name: characterNames[index],
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No characters found'));
                }
              })),
    );
  }
}

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
