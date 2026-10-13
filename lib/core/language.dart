import 'dart:convert';

/// A language that appears in the vocabulary data and in the menus.
///
/// Languages are described in `data/languages.json`; adding a language there
/// (plus its columns in the CSV and its menu translation file) is all that is
/// needed for it to show up in the app.
class Language {
  const Language({
    required this.code,
    required this.column,
    required this.rtl,
    required this.ttsLocale,
    required this.names,
    this.articles = const [],
  });

  /// Short code such as `en` or `fa`; also the menu locale code.
  final String code;

  /// Name of the word column in the CSV, e.g. `english`.
  final String column;

  /// Whether the language is written right to left.
  final bool rtl;

  /// Locale passed to text-to-speech, e.g. `de-DE`.
  final String ttsLocale;

  /// Name of this language in every menu language, keyed by language code.
  final Map<String, String> names;

  /// Articles that nouns start with (`der`, `die`, `das`), ignored when sorting.
  final List<String> articles;

  /// [word] without its leading article, lower-cased, for alphabetical order.
  String sortKey(String word) {
    final lower = word.toLowerCase();
    for (final article in articles) {
      if (lower.startsWith('$article ')) return lower.substring(article.length + 1);
    }
    return lower;
  }

  /// Name of this language for the given menu language, falling back to English.
  String nameIn(String uiCode) => names[uiCode] ?? names['en'] ?? code;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    code: json['code'] as String,
    column: json['column'] as String,
    rtl: json['rtl'] as bool? ?? false,
    ttsLocale: json['ttsLocale'] as String,
    names: (json['names'] as Map<String, dynamic>).cast<String, String>(),
    articles: (json['articles'] as List?)?.cast<String>() ?? const [],
  );

  Map<String, dynamic> toJson() => {
    'code': code,
    'column': column,
    'rtl': rtl,
    'ttsLocale': ttsLocale,
    'names': names,
    'articles': articles,
  };

  static List<Language> listFromJson(String source) {
    final json = jsonDecode(source) as Map<String, dynamic>;
    return (json['languages'] as List)
        .map((e) => Language.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  bool operator ==(Object other) => other is Language && other.code == code;

  @override
  int get hashCode => code.hashCode;
}

/// CEFR levels in order.
const levels = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
