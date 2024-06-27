import '../element.dart';

/// Novel List Finder
class NovelListFinder {
  /// Creates a new instance of [NovelListFinder].
  NovelListFinder({
    required this.url,
    required this.novel,
    required this.title,
    required this.cover,
    required this.link,
  });

  /// The URL of the novel list page.
  final String url;

  /// Novel item selector.
  final String novel;

  /// Novel item title selector.
  final Element title;

  /// Novel item cover selector.
  final Element cover;

  /// Novel item link selector.
  final Element link;

  /// Converts the [NovelListFinder] to a string.
  @override
  String toString() {
    return 'url: $url, novel: $novel, title: $title, link: $link';
  }
}
