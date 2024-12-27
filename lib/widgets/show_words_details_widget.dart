import 'package:english_test/services/api_words_service.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class ShowWordDetailsWidget extends StatefulWidget {
  final String word;
  final String phonetics;
  final List<dynamic> meanings;
  final String audioUrl;
  final List<String> wordList;
  final int currentIndex;

  const ShowWordDetailsWidget({
    Key? key,
    required this.word,
    required this.phonetics,
    required this.meanings,
    required this.audioUrl,
    required this.wordList,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<ShowWordDetailsWidget> createState() => _ShowWordDetailsWidgetState();
}

class _ShowWordDetailsWidgetState extends State<ShowWordDetailsWidget> {
  late final AudioPlayer _audioPlayer;
  late int _currentIndex;
  bool _isPlaying = false;
  bool _hasPlayed = false;
  bool _isLoading = false;
  bool hasAudio = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.currentIndex;
    _audioPlayer = AudioPlayer();
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
      });
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if (hasAudio) {
      try {
        setState(() => _isLoading = true);
        await _audioPlayer.setUrl(widget.audioUrl);
        await _audioPlayer.play();
        await _audioPlayer.stop();
        setState(() {
          _hasPlayed = true;
          _isLoading = false;
        });
      } catch (e) {
        setState(() {
          hasAudio = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToWord(int newIndex) async {
    if (newIndex < 0 || newIndex >= widget.wordList.length) return;

    final newWord = widget.wordList[newIndex];
    try {
      final wordDetails = await ApiWordService().fetchWordDetails(newWord);

      Navigator.of(context).pop(); // Fecha o diálogo atual
      showDialog(
        context: context,
        builder: (context) => ShowWordDetailsWidget(
          word: newWord,
          phonetics: wordDetails['phonetics'],
          meanings: wordDetails['meanings'],
          audioUrl: wordDetails['audio'],
          wordList: widget.wordList,
          currentIndex: newIndex,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load word details: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 16),
              Text(
                widget.word,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (widget.phonetics.isNotEmpty)
                Text(
                  widget.phonetics,
                  style: const TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
                ),
              const SizedBox(height: 16),
              if (hasAudio)
                Row(
                  children: [
                    IconButton(
                      icon: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(color: Colors.black))
                          : Icon(
                              _isPlaying
                                  ? Icons.pause
                                  : (_hasPlayed
                                      ? Icons.replay_outlined
                                      : Icons.play_arrow),
                            ),
                      onPressed: _isLoading ? null : _playAudio,
                    ),
                    const Text('Play Audio'),
                  ],
                )
              else
                Row(
                  children: [
                    const Icon(Icons.error_outline),
                    const SizedBox(width: 8),
                    const Text(
                      'No audio available.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              const SizedBox(height: 16),
              const Text(
                'Meanings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              if (widget.meanings.isNotEmpty)
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.meanings.length,
                  itemBuilder: (context, index) {
                    final meaning = widget.meanings[index];
                    final partOfSpeech = meaning['partOfSpeech'] ?? 'N/A';
                    final definitions = meaning['definitions'] ?? [];

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          partOfSpeech,
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        ...definitions.map<Widget>((definition) {
                          final definitionText =
                              definition['definition'] ?? 'No definition provided';
                          final exampleText = definition['example'] ?? '';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('- $definitionText'),
                                if (exampleText.isNotEmpty)
                                  Text(
                                    'Example: "$exampleText"',
                                    style: const TextStyle(
                                        fontStyle: FontStyle.italic),
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  },
                )
              else
                const Text('No meanings available.',
                    style: TextStyle(fontSize: 16)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _currentIndex > 0
                        ? () => _navigateToWord(_currentIndex - 1)
                        : null,
                    child: const Text('Back'),
                  ),
                  ElevatedButton(
                    onPressed: _currentIndex < widget.wordList.length - 1
                        ? () => _navigateToWord(_currentIndex + 1)
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
  }
}