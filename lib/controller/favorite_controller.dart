import 'dart:ui';

import 'package:english_test/models/words_model.dart';
import 'package:english_test/services/api_words_service.dart';
import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class FavoriteController extends ChangeNotifier {
    final SqlDataBase _dbHelper = SqlDataBase();
  ValueNotifier<List<String>> wordfavorites = ValueNotifier([]);
  WordsModel? wordsModel;

  void setState(VoidCallback fn) {
    fn();
  }


  Future<void> loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
   
      wordfavorites.value = favorites.map((e) => e['word'] as String).toList();
    
  }

  Future<void> removeFavorite(String word) async {
    await _dbHelper.deleteFavorite(word);
    await loadFavorites();
  }

  Future<void> removeallFavorite() async {
    await _dbHelper.deleteallFavorite();
    await loadFavorites();
  }

   Future<void> showWordDetails(BuildContext context, String word) async {
    try {
      final wordDetails = await ApiWordService().fetchWordDetails(word);

      // ignore: unnecessary_null_comparison
      if (wordDetails != null) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => ShowWordDetails( wordsModel: wordDetails, // ✅ Passando o modelo correto
            wordsList: [], // ✅ Você pode ajustar essa lista conforme necessário
            currentIndex: 0, // ✅ Defina um índice apropriado
           
           ),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details for "$word" not found.')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load details: $e')),
      );
    }
  }
}