import 'package:flutter/material.dart';
import 'character_fetcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Star Wars Characters',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CharacterListScreen(title: 'Star Wars Characters'),
    );
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
                      return ListTile(
                        title: Text(characterNames[index]),
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
