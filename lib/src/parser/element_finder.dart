/// Novel List Finder
class ElementFinder {
  /// Creates a new instance of [ElementFinder].
  ElementFinder({
    required this.url,
    required this.script,
    this.nextButtonSelector,
  });

  /// The URL of the novel list page.
  final String url;

  /// The script to extract the novel list.
  final String script;

  /// The selector for the next button.
  final String? nextButtonSelector;

  /// Converts the [ElementFinder] to a string.
  @override
  String toString() {
    return 'NovelListFinder(url: $url, script: $script)';
  }
}
