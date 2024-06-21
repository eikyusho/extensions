import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import 'enums/enums.dart';
import 'parser/element.dart';
import 'parser/novel_list_finder.dart';
import 'utils/logger.dart';

/// Extracts data from an XML source.
class EikyushoParser {
  /// Creates a new instance of [EikyushoParser].
  const EikyushoParser(this.document);

  /// The XML document.
  final String document;

  XmlDocument get _document => XmlDocument.parse(document);

  XmlElement get _root => _document.rootElement;

  XmlName get _xmlName => _document.rootElement.name;

  XmlElement get _discover => _root.getElement('discover')!;

  XmlElement get _metadata => _root.getElement('metadata')!;

  /// Gets the name.
  String get name => _metadata.getElement('name')?.innerText ?? '';

  /// Gets the base URL.
  String get baseUrl => _metadata.getElement('base-url')?.innerText ?? '';

  /// Gets the version.
  String get version => _metadata.getElement('version')?.innerText ?? '';

  /// Gets the language.
  String get language => _metadata.getElement('language')?.innerText ?? '';

  /// Gets the novel list.
  NovelListFinder getNovelList(DiscoverListType type) {
    final list = _discover.xpath('//novel-list[@id="${type.value}"]').first;

    return _getNovelList(list);
  }

  NovelListFinder _getNovelList(XmlNode novelList) {
    final url = novelList.getAttribute('url');

    final novelItem = novelList.findElements('novel-item').first;

    final selector = novelItem.getAttribute('selector');
    final titleSelector = _getElement(novelItem.getElement('title'));
    final coverSelector = _getElement(novelItem.getElement('cover'));
    final linkSelector = _getElement(novelItem.getElement('link'));

    return NovelListFinder(
      url: url!,
      novel: selector!,
      title: titleSelector,
      cover: coverSelector,
      link: linkSelector,
    );
  }

  Element _getElement(XmlNode? node) {
    if (node == null) throw Exception('Element not found');

    final selector = node.innerText;
    final attribute = node.getAttribute('attribute');

    return Element(selector: selector, attribute: attribute);
  }

  /// Validates the XML document.
  void printEverything() {
    AppLogger.debug('Root element: $_xmlName');
    // logPrint('Discover element: ${_discover.innerText}');

    final trending = getNovelList(DiscoverListType.trending);
    final mostPopular = getNovelList(DiscoverListType.mostPopular);
    final recentlyUpdated = getNovelList(DiscoverListType.recentlyUpdated);
  }
}
