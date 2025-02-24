class WordsModel {
  final String word;
  final String phonetics;
  final String audioUrl;
  final List<String> meanings;

  WordsModel({
    required this.word,
    required this.phonetics,
    required this.audioUrl,
    required this.meanings,
  });

  factory WordsModel.fromJson(Map<String, dynamic> json) {
    return WordsModel(
      word: json['word'] ?? '',
      phonetics: (json['phonetics'] != null && (json['phonetics'] as List).isNotEmpty)
          ? json['phonetics'][0]['text'] ?? ''
          : '',
      audioUrl: (json['phonetics'] != null && (json['phonetics'] as List).isNotEmpty)
          ? json['phonetics'][0]['audio'] ?? ''
          : '',
      meanings: (json['meanings'] != null)
          ? (json['meanings'] as List)
              .expand((meaning) => (meaning['definitions'] as List)
                  .map((definition) => definition['definition'].toString()))
              .toList()
          : [],
    );
  }
}
