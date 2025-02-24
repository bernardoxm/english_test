import 'package:english_test/models/words_model.dart';
import 'package:english_test/services/api_words_service.dart';
import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
// Add this import

class ShowWordsController extends ChangeNotifier {
  final AudioPlayer audioPlayer = AudioPlayer();
  final List<WordsModel> wordsList; // Agora a lista completa é passada
  WordsModel wordsModel;
  bool isFavorite = false;
  int currentIndex;
  bool isPlaying = false;
  bool hasPlayed = false;
  bool isLoading = false;
  bool hasAudio = true;


  ShowWordsController({
    required this.wordsModel,
    required this.wordsList,
    required this.currentIndex,
  }) {
    checkIfFavorite();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  Future<void> checkIfFavorite() async {
    final favorites = await SqlDataBase().getFavorites();
    isFavorite = favorites.any((fav) => fav['word'] == wordsModel.word);
    notifyListeners();
  }

  Future<void> insertFavorite() async {
    await SqlDataBase().insertFavorite(wordsModel.word);
    isFavorite = true;
    notifyListeners();
  }

  Future<void> deleteFavorite() async {
    await SqlDataBase().deleteFavorite(wordsModel.word);
    isFavorite = false;
    notifyListeners();
  }

  Future<void> playAudio() async {
    if (wordsModel.audioUrl.isEmpty) {
      hasAudio = false;
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      await audioPlayer.setUrl(wordsModel.audioUrl);
      await audioPlayer.play();
      await audioPlayer.stop();

      hasPlayed = true;
      isLoading = false;
      notifyListeners();
    } catch (e) {
      hasAudio = false;
      isLoading = false;
      notifyListeners();
    }
  }

 
  Future<void> navigateToWord(int newIndex, BuildContext context) async {
  if (newIndex < 0 || newIndex >= wordsList.length) return;

  final newWord = wordsList[newIndex];

  try {
    final wordDetails = await ApiWordService().fetchWordDetails(newWord.word);
    await SqlDataBase().insertHistory(newWord.word);

    final db = SqlDataBase();
    final favorites = await db.getFavorites();
    final isAlreadyFavorite = favorites.any((fav) => fav['word'] == newWord.word);

    if (context.mounted) {
      Navigator.of(context).pop();
      showDialog(
        context: context,
        builder: (context) => ShowWordDetails(
          wordsModel: wordDetails,
          wordsList: wordsList,
          currentIndex: newIndex,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load word details: $e')),
      );
    }
  }
}

}
