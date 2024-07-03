import 'dart:convert';
import 'package:http/http.dart' as http;

class CharacterFetcher {
  final String baseUrl = 'https://swapi.dev/api/';

  Future<List<String>> fetchCharacterNames() async {
    List<String> characterNames = [];
    String? nextUrl = '${baseUrl}people/';

    while (nextUrl != null) {
      final response = await http.get(Uri.parse(nextUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        for (var character in data['results']) {
          characterNames.add(character['name']);
        }
        nextUrl = data['next'];
      } else {
        throw Exception('Failed to load characters');
      }
    }

    return characterNames;
  }
}
