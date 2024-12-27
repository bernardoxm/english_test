import 'package:flutter/material.dart';

class WordHistoryProvider extends ChangeNotifier {
  final List<String> _clickedWords = [];

  List<String> get clickedWords => List.unmodifiable(_clickedWords);

  void addWord(String word) {
    if (!_clickedWords.contains(word)) {
      _clickedWords.add(word);
      notifyListeners();
    }
  }
}
