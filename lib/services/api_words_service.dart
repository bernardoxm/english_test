import 'dart:convert';
import 'package:english_test/models/words_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class ApiWordService {
  static const String _baseUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';

  /// **📥 Carrega a lista do JSON local (se não houver API para isso)**
  Future<List<String>> fetchWordList() async {
    try {
      final String jsonString = await rootBundle.loadString('assets/words/words.json');
      final dynamic decodedJson = jsonDecode(jsonString);

      if (decodedJson is List && decodedJson.every((item) => item is String)) {
        return List<String>.from(decodedJson);
      } else {
        throw Exception("Formato do JSON inválido!");
      }
    } catch (error) {
      throw Exception('Erro ao carregar lista de palavras: ${error.toString()}');
    }
  }

  /// **📖 Busca detalhes da palavra na API**
  Future<WordsModel> fetchWordDetails(String word) async {
    try {
      final url = Uri.parse('$_baseUrl/$word');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final Map<String, dynamic> wordData = data.first;

        final List<dynamic>? phoneticsList = wordData['phonetics'] as List<dynamic>?;
        final String phonetics = (phoneticsList != null && phoneticsList.isNotEmpty)
            ? (phoneticsList[0]['text'] ?? '')
            : '';
        final String audio = (wordData['phonetics'] != null && (wordData['phonetics'] as List).isNotEmpty)
            ? (wordData['phonetics'][0]['audio'] ?? '')
            : '';
        final List<dynamic> meanings = wordData['meanings'] as List<dynamic>? ?? [];

        if (kDebugMode) {
          print(audio);
        }

        return WordsModel(
          word: wordData['word'] ?? word,
          phonetics: phonetics,
          audioUrl: audio.isNotEmpty ? (audio.startsWith('http') ? audio : 'https:$audio') : '',
          meanings: meanings
              .expand((meaning) => (meaning['definitions'] as List)
                  .map((definition) => definition['definition'].toString()))
              .toList(),
        );
      } else {
        throw Exception('Palavra não encontrada: $word. Código: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Erro ao buscar detalhes: ${error.toString()}');
    }
  }
}
