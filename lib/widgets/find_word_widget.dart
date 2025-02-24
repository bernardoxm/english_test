import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:english_test/controller/word_list_controller.dart';

class FindWordWidget extends StatelessWidget {
  const FindWordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final wordListController = context.read<WordListController>();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: wordListController.searchController,
        onChanged: (query) => wordListController.searchWord(query),
        decoration: InputDecoration(
          hintText: 'Type a word...',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.black),
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              wordListController.searchController.clear();
              wordListController.searchWord('');
              onSubmitted: (query) {
                wordListController.searchWord(query);
              };
            },
          ),
        ),
      ),
    );
  }
}
