/// Novel List Finder
class ElementFinder {
  /// Creates a new instance of [ElementFinder].
  ElementFinder({required this.url, required this.script});

  /// The URL of the novel list page.
  final String url;

  /// The script to extract the novel list.
  final String script;

  /// Converts the [ElementFinder] to a string.
  @override
  String toString() {
    return 'NovelListFinder(url: $url, script: $script)';
  }
}
