import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:english_test/services/api_words_service.dart';

class HistoryTab extends StatefulWidget {
  const HistoryTab({super.key});

  @override
  _HistoryTabState createState() => _HistoryTabState();
}

class _HistoryTabState extends State<HistoryTab> {
  final SqlDataBase _db = SqlDataBase();
  List<Map<String, dynamic>> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final history = await _db.getHistory();
    setState(() {
      _history = history;
    });
  }

  Future<void> _removeHistoryEntry(String word) async {
    await _db.clearHistory();
    _loadHistory();
  }

  Future<void> _showWordDetails(String word) async {
    try {
      final wordDetails = await ApiWordService().fetchWordDetails(word);

      if (wordDetails != null) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => ShowWordDetails(
            word: word,
            phonetics: wordDetails['phonetics'] ?? '',
            meanings: wordDetails['meanings'] ?? [],
            audioUrl: wordDetails['audio'] ?? '',
            wordList: _history.map((e) => e['word'] as String).toList(),
            currentIndex: _history.indexWhere((e) => e['word'] == word),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Details for "$word" not found.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _removeHistoryEntry(""), // Remove todo o histórico
          ),
        ],
      ),
      body: _history.isEmpty
          ? const Center(child: Text('No history available'))
          : ListView.builder(
              itemCount: _history.length,
              itemBuilder: (context, index) {
                final word = _history[index]['word'];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () => _showWordDetails(word),
                    child: ListTile(
                      title: Text(word),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeHistoryEntry(word),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
