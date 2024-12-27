import 'package:flutter/material.dart';

class FavoritesTab extends StatelessWidget {
  final List<String> favoriteWords;
  final void Function(String word) onRemoveFavorite;
  final void Function(String word) onWordTap;

  const FavoritesTab({
    Key? key,
    required this.favoriteWords,
    required this.onRemoveFavorite,
    required this.onWordTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Column(
      children: [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'History',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: favoriteWords.length,
            itemBuilder: (context, index) {
              final word = favoriteWords[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4.0),
                child: ListTile(
                  title: Text(word, style: const TextStyle(fontSize: 16)),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => onRemoveFavorite(word), // Chama o callback para remover
                  ),
                  onTap: () => onWordTap(word), // Chama o callback ao tocar na palavra
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
