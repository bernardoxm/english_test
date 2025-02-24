import 'package:english_test/models/words_model.dart';
import 'package:english_test/services/api_words_service.dart';
import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';
import 'package:flutter/material.dart';

class HistController extends ChangeNotifier {
  final SqlDataBase _db = SqlDataBase();
  ValueNotifier<List<Map<String, dynamic>>> historyList = ValueNotifier([]);

  Future<void> loadHistory() async {
    final history = await _db.getHistory();
    historyList.value = history;
    notifyListeners();
  }

  Future<void> removeHistoryEntry(String word) async {
    await _db.clearHistory();
    await loadHistory();
    notifyListeners();
  }

  Future<void> removeHistoryEntryOnly(String word) async {
    await _db.clearHistoryOnly(word);
    await loadHistory();
    notifyListeners();
  }

  Future<void> showWordDetails(BuildContext context, String word) async {
    try {
      final wordDetails = await ApiWordService().fetchWordDetails(word);
      if (!context.mounted) return;

      if (wordDetails != null) {
        showDialog(
          context: context,
          builder: (context) => ShowWordDetails(
            wordsModel: wordDetails, // ✅ Passando o modelo correto
            wordsList: [], // ✅ Você pode ajustar essa lista conforme necessário
            currentIndex: 0, // ✅ Defina um índice apropriado
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details for "$word" not found.')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load details: $e')),
        );
      }
    }
    notifyListeners();
  }
}
