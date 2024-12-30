import 'package:english_test/sql/sql_data_base.dart';
import 'package:english_test/widgets/show_words_details_widget.dart';
import 'package:flutter/material.dart';
import 'package:english_test/services/api_words_service.dart';


class FavoritesTab extends StatefulWidget {
  const FavoritesTab({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FavoritesTabState createState() => _FavoritesTabState();
}

class _FavoritesTabState extends State<FavoritesTab> {
  final SqlDataBase _dbHelper = SqlDataBase();
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _dbHelper.getFavorites();
    setState(() {
      _favorites = favorites.map((e) => e['word'] as String).toList();
    });
  }

  Future<void> _removeFavorite(String word) async {
    await _dbHelper.deleteFavorite(word);
    _loadFavorites();
  }

  Future<void> _showWordDetails(String word) async {
    try {
      final wordDetails = await ApiWordService().fetchWordDetails(word);

      // ignore: unnecessary_null_comparison
      if (wordDetails != null) {
        showDialog(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => ShowWordDetails(
            word: word,
            phonetics: wordDetails['phonetics'] ?? '',
            meanings: wordDetails['meanings'] ?? [],
            audioUrl: wordDetails['audio'] ?? '',
            wordList: _favorites,
            currentIndex: _favorites.indexOf(word),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true,
        title: const Text('Favorites',),
      ),
      body: _favorites.isEmpty
          ? const Center(child: Text('No favorites yet!'))
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final word = _favorites[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    
                    onPressed:() => _showWordDetails(word),
                    child: ListTile(
                      title: Text(word),
                   
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeFavorite(word),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
