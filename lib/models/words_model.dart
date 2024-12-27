class WordsModel {
  final String word;
  final String phonetics;
  final String audioUrl;
  final List<String> definitions;

  WordsModel({
    required this.word,
    required this.phonetics,
    required this.audioUrl,
    required this.definitions,
  });

  factory WordsModel.fromJson(Map<String, dynamic> json) {
    return WordsModel(
      word: json['word'],
      phonetics: json['phonetics']?.isNotEmpty == true
          ? json['phonetics'][0]['text'] ?? ''
          : '',
      audioUrl: json['phonetics']?.isNotEmpty == true
          ? json['phonetics'][0]['audio'] ?? ''
          : '',
      definitions: (json['meanings'] as List)
          .expand((meaning) => (meaning['definitions'] as List)
              .map((definition) => definition['definition'] as String))
          .toList(),
    );
  }
}
