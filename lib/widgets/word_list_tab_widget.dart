import 'package:english_test/widgets/find_word_widget.dart';
import 'package:flutter/material.dart';
import 'package:english_test/controller/word_list_controller.dart';
import 'package:provider/provider.dart';

class WordListTab extends StatefulWidget {
  const WordListTab({super.key});

  @override
  State<WordListTab> createState() => _WordListTabState();
}

class _WordListTabState extends State<WordListTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<WordListController>().loadWordsFromFile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<WordListController>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Word List'),
        actions: [
          Row(
            children: [
              if(controller.find.value == false)
              Text('Search:'),
              IconButton(
                onPressed: () => controller.toggleSearch(),
                icon: Icon(controller.find.value ? Icons.close : Icons.search),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          if (controller.find.value) const FindWordWidget(),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: controller.filteredList,
              builder: (context, words, child) {
                if (words.isEmpty) {
                  return const Center(child: Text("No words found."));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    childAspectRatio: 2,
                  ),
                  itemCount: words.length,
                  itemBuilder: (context, index) {
                    final word = words[index];

                    return ElevatedButton(
                      onPressed: () {
                        if (word.startsWith("🔍 Search")) {
                          String searchQuery = word
                              .replaceAll("🔍 Search \"", "")
                              .replaceAll("\" on web", "");
                          context
                              .read<WordListController>()
                              .fetchWordDetails(context, searchQuery);
                        } else {
                          context
                              .read<WordListController>()
                              .fetchWordDetails(context, word);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        word,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
