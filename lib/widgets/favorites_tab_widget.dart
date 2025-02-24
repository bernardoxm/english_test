import 'package:english_test/controller/favorite_controller.dart';
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
  final FavoriteController _favoriteController = FavoriteController();

  @override
  void initState() {
    super.initState();
  
    _favoriteController.loadFavorites();
    
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _favoriteController.wordfavorites,
      builder: (context, List<String> wordfavorites, child) { 
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text(
              'Favorites', 
            ),actions: [ IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _favoriteController.removeallFavorite(), // Remove todo o histórico
              ),],
          ),
          body: wordfavorites.isEmpty
              ? const Center(child: Text('No favorites yet!'))
              : ListView.builder(
                  itemCount: wordfavorites.length,
                  itemBuilder: (context, index) {
                    final word = wordfavorites[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                        onPressed: () =>
                            _favoriteController.showWordDetails(context, word),
                        child: ListTile(
                          title: Text(word),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _favoriteController.removeFavorite(word),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      }
    );
  }
}
