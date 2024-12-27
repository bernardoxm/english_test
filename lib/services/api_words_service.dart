import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiWordService {
  final String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  Future<Map<String, dynamic>> fetchWordDetails(String word) async {
    try {
      final url = Uri.parse('$_baseUrl/$word');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> wordData = data.first;

        final String phonetics = (wordData['phonetics'] as List).isNotEmpty
            ? (wordData['phonetics'][0]['text'] ?? '')
            : 'Not available';
        final String audio = (wordData['phonetics'] as List).isNotEmpty
            ? (wordData['phonetics'][0]['audio'] ?? '')
            : '';
        final List<dynamic> meanings = wordData['meanings'] ?? [];
print(audio);
        return {
          'word': wordData['word'] ?? word,
          'phonetics': phonetics,
          'audio': audio.startsWith('http') ? audio : 'https:$audio',
          'meanings': meanings,
          
        };
        
      } else {
        throw Exception('Failed to fetch details for word: $word');
      }
    } catch (error) {
      throw Exception('Error fetching word details: $error');
    }
  }
}
