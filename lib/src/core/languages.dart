/// Language class
final class Language {
  /// Creates a new instance of [Language].
  const Language._();

  /// Language codes and names.
  static const languages = <String, String>{
    'de': 'Deutsch',
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'pt': 'Português',
  };

  /// Gets the language code.
  static String getCode(String name) {
    return languages.entries.firstWhere((e) => e.value == name).key;
  }

  /// Gets the language name.
  static String getName(String code) {
    return languages[code]!;
  }

  /// Validates the language code.
  static String validate(String code) {
    if (!languages.containsKey(code)) {
      throw Exception('Invalid language code');
    }

    return code;
  }
}
