import '../element.dart';

/// Novel List Finder
class NovelFinder {
  /// Creates a new instance of [NovelFinder].
  NovelFinder({
    required this.url,
    required this.title,
    required this.cover,
    required this.author,
    required this.chapterCount,
    required this.views,
    required this.status,
  });

  /// The URL of the novel list page.
  final String url;

  /// Novel item title selector.
  final Element title;

  /// Novel item cover selector.
  final Element cover;

  /// Novel item author selector.
  final Element author;

  /// Novel item views selector.
  final Element views;

  /// Novel chapter count selector.
  final Element chapterCount;

  /// Novel status selector.
  final Element status;

  /// Converts the [NovelFinder] to a string.
  @override
  String toString() {
    return 'url: $url, title: $title,  chapterCount: $chapterCount';
  }
}
