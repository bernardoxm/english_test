import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:english_test/widgets/error_load_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:english_test/models/words_model.dart';
import 'package:english_test/services/api_words_service.dart';
import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';

class WordListController extends ChangeNotifier {
  final ApiWordService apiWordService = ApiWordService();

  ValueNotifier<List<String>> wordList = ValueNotifier([]);
  ValueNotifier<List<String>> filteredList = ValueNotifier([]);
  ValueNotifier<bool> find = ValueNotifier(false);
  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool hasError = false;
  String errorMessage = '';

  /// **🔎 Ativa ou desativa a barra de busca**
  void toggleSearch() {
    find.value = !find.value;
    if (!find.value) {
      searchController.clear();
      filteredList.value = wordList.value;
    }
    notifyListeners();
  }

  /// **🔍 Filtra palavras dentro da lista original e adiciona a opção de buscar na API**
  void searchWord(String query) {
    if (query.isEmpty) {
      filteredList.value = wordList.value;
    } else {
      List<String> localMatches = wordList.value
          .where((word) => word.toLowerCase().contains(query.toLowerCase()))
          .toList();

      if (localMatches.isNotEmpty) {
        filteredList.value = localMatches;
      } else {
        // 🔍 Se a palavra não estiver na lista, exibe um botão de pesquisa na API
        filteredList.value = ["🔍 Search \"$query\" on web"];
      }
    }
    notifyListeners();
  }

  /// **📥 Carrega a lista do JSON**
  Future<void> loadWordsFromFile() async {
    isLoading = true;
    hasError = false;
    notifyListeners();

    try {
      final String jsonString =
          await rootBundle.loadString('assets/words/words.json');
      final dynamic decodedJson = jsonDecode(jsonString);

      if (decodedJson is List && decodedJson.every((item) => item is String)) {
        wordList.value = List<String>.from(decodedJson);
        filteredList.value = List<String>.from(decodedJson);
      } else {
        throw Exception("Formato do JSON inválido!");
      }
    } catch (error) {
      hasError = true;
      errorMessage = 'Erro ao carregar palavras: $error';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// **📖 Busca detalhes da palavra na API**
 /// **📖 Busca detalhes da palavra na API**
Future<void> fetchWordDetails(BuildContext context, String word) async {
  var connectivityResult = await Connectivity().checkConnectivity();
  
  if (connectivityResult == ConnectivityResult.none) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ErrorLoad(
            message: "No internet connection. Please enable WiFi or mobile data.",
            onRetry: () {
              Navigator.pop(context);
              fetchWordDetails(context, word); // Retry after enabling internet
            },
          ),
        ),
      );
    }
    return;
  }

  try {
    final WordsModel wordDetails = await apiWordService.fetchWordDetails(word);
    final db = SqlDataBase();
    await db.insertHistory(word);

    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => ShowWordDetails(
          wordsModel: wordDetails,
          wordsList: wordList.value
              .map((w) => WordsModel(word: w, phonetics: '', audioUrl: '', meanings: []))
              .toList(),
          currentIndex: wordList.value.indexOf(word),
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: ErrorLoad(
            message: "Word not found. Please try a different word.",
            onRetry: () {
              Navigator.pop(context);
            },
          ),
        ),
      );
    }
  }
}

}
// Compare this snippet from lib/controller/favorite_controller.dart:
