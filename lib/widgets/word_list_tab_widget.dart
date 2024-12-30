import 'dart:convert';
import 'package:english_test/services/api_words_service.dart';
import 'package:english_test/sql/sql_data_base.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'error_load_widget.dart';
import 'show_words_details_widget.dart';

class WordListTab extends StatefulWidget {
  const WordListTab(
      {super.key,
      required void Function(String word, Map<String, dynamic> wordDetails)
          onWordTap});

  @override
  State<WordListTab> createState() => _WordListTabState();
}

class _WordListTabState extends State<WordListTab> {
  final ApiWordService _apiWordService = ApiWordService();
  List<String> _wordList = [];
  bool _isLoading = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadWordsFromFile();
  }

  Future<void> _loadWordsFromFile() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      final String jsonString =
          await rootBundle.loadString('assets/words/words.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      setState(() {
        _wordList = jsonList.cast<String>();
      });
    } catch (error) {
      setState(() {
        _hasError = true;
        _errorMessage = 'Failed to load words: $error';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildWordGrid() {
    return Scaffold(
      appBar: AppBar(centerTitle: true,title: const Text('Word List')),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 2,
              ),
              itemCount: _wordList.length,
              itemBuilder: (context, index) {
                return ElevatedButton(
                  onPressed: () async {
                    final String selectedWord = _wordList[index];
                    try {
                      final Map<String, dynamic> wordDetails =
                          await _apiWordService.fetchWordDetails(selectedWord);

                      if (kDebugMode) {
                        print('Word details fetched: $wordDetails');
                      }

                      final db = SqlDataBase();
                      await db.insertHistory(selectedWord);
                    
                     
                      showDialog(
                        // ignore: use_build_context_synchronously
                        context: context,
                        builder: (context) => ShowWordDetails(
                          word: selectedWord,
                          phonetics: wordDetails['phonetics'] ?? [],
                          meanings: wordDetails['meanings'] ?? [],
                          audioUrl: wordDetails['audio'] ?? '',
                          wordList: _wordList,
                          currentIndex: index,
                        ),
                      );
                    } catch (e, stackTrace) {
                      if (kDebugMode) {
                        print('Error occurred: $e'); print('Stack trace: $stackTrace');
                      }
                     

                      setState(() {
                        _hasError = true;
                        _errorMessage = e.toString();
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    _wordList[index],
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return ErrorLoad(
        message: _errorMessage,
        onRetry: () {
          setState(() {
            _hasError = false;
            _errorMessage = '';
          });
          _loadWordsFromFile();
        },
      );
    }

    return _buildWordGrid();
  }
}
