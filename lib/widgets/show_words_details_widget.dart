import 'package:english_test/models/words_model.dart';
import 'package:flutter/material.dart';
import 'package:english_test/controller/show_words_controller.dart';
import 'package:provider/provider.dart';

class ShowWordDetails extends StatefulWidget {
  const ShowWordDetails({
    super.key,
    required this.wordsModel,
    required this.wordsList,
    required this.currentIndex,
  });

  final WordsModel wordsModel;
  final List<WordsModel> wordsList;
  final int currentIndex;

  @override
  State<ShowWordDetails> createState() => _ShowWordDetailsState();
}

class _ShowWordDetailsState extends State<ShowWordDetails> {
  late ShowWordsController _showWordsController;

  @override
  void initState() {
    super.initState();
    _showWordsController = ShowWordsController(
      wordsModel: widget.wordsModel,
      wordsList: widget.wordsList,
      currentIndex: widget.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _showWordsController,
      child: Consumer<ShowWordsController>(
        builder: (context, controller, child) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          controller.wordsModel.word,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: Icon(
                            controller.isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: controller.isFavorite ? Colors.red : Colors.grey,
                          ),
                          onPressed: () {
                            controller.isFavorite
                                ? controller.deleteFavorite()
                                : controller.insertFavorite();
                          },
                        ),
                      ],
                    ),
                    if (controller.wordsModel.phonetics.isNotEmpty)
                      Text(
                        controller.wordsModel.phonetics,
                        style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                      ),
                    const SizedBox(height: 16),
                    if (controller.wordsModel.audioUrl.isNotEmpty)
                      Row(
                        children: [
                          IconButton(
                            icon: controller.isLoading
                                ? const Icon(Icons.stop_outlined , color: Colors.red)
                                : Icon(
                                    controller.hasPlayed ? Icons.replay_outlined : Icons.play_arrow,
                                    color: Colors.blue,
                                  ),
                            onPressed: controller.playAudio,
                          ),
                          const Text('Play Audio'),
                        ],
                      ),
                    const SizedBox(height: 16),
                    const Text('Meanings', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    ...controller.wordsModel.meanings.map((meaning) => Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text('- $meaning'),
                        )),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: controller.currentIndex > 0
                              ? () => controller.navigateToWord(controller.currentIndex - 1, context)
                              : null,
                          child: const Text('Back'),
                        ),
                        ElevatedButton(
                          onPressed: controller.currentIndex < controller.wordsList.length - 1
                              ? () => controller.navigateToWord(controller.currentIndex + 1, context)
                              : null,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
