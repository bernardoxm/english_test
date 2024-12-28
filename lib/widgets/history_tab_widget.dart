import 'package:flutter/material.dart';

class HistoryTab extends StatelessWidget {
  final List<String> historyWords;
  final void Function(String word) onDelete;
  final void Function(String word) onWordTap;

  const HistoryTab({
    super.key,
    required this.historyWords,
    required this.onDelete,
    required this.onWordTap, required List clickedWords,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        children: [ Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: historyWords.length,
              itemBuilder: (context, index) {
                final word = historyWords[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: ListTile(
                    title: Text(word, style: const TextStyle(fontSize: 16)),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => onDelete(word), 
                    ),
                    onTap: () => onWordTap(word),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
