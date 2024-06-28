import 'package:xml/xml.dart';
import 'package:xml/xpath.dart';

import '../enums/enums.dart';
import '../parser/element_finder.dart';

/// Extracts data from an XML source.
class EikyushoParser {
  /// Creates a new instance of [EikyushoParser].
  const EikyushoParser(this.document);

  /// The XML document.
  final String document;

  XmlDocument get _document => XmlDocument.parse(document);

  XmlElement get _root => _document.rootElement;

  XmlName get _xmlName => _document.rootElement.name;

  XmlElement get _metadata => _root.getElement('metadata')!;

  XmlElement get _discover => _root.getElement('discover')!;

  /// Gets the name.
  String get name => _metadata.getElement('name')?.innerText ?? '';

  /// Gets the base URL.
  String get baseUrl => _metadata.getElement('base-url')?.innerText ?? '';

  /// Gets the version.
  String get version => _metadata.getElement('version')?.innerText ?? '';

  /// Verifies if the extension is obsolete.
  bool get isObsolete => _metadata.getElement('version')?.innerText == 'null';

  /// Gets the language.
  String get language => _metadata.getElement('language')?.innerText ?? '';

  /// Gets the status map.
  Map<String, String> statusMap() {
    final statusMapElement = _metadata.getElement('novel-status-map')!;
    final statusMap = <String, String>{};

    for (final status in statusMapElement.findElements('*')) {
      statusMap[status.name.toString().toLowerCase()] = status.innerText;
    }

    return statusMap;
  }

  /// Gets the novel list.
  ElementFinder getNovelList(DiscoverListType type) {
    final list = _discover.xpath('//novel-list[@id="${type.value}"]').first;

    return ElementFinder(
      url: list.getAttribute('url')!,
      script: _getXPathScript(list),
    );
  }

  /// Gets the novel.
  ElementFinder getNovelDetails(String url) {
    final novel = _root.getElement('novel')!;


    return ElementFinder(
      url: url,
      script: _getScript(novel),
    );
  }

  /// Gets the novel chapters.
  ElementFinder getNovelChapters(String url) {
    final novel = _root.getElement('novel-chapters-list')!;

    return ElementFinder(
      url: '$url/${novel.getAttribute('url')}',
      script: _getScript(novel),
      nextButtonSelector: novel.getAttribute('next-button'),
    );
  }

  String _getXPathScript(XmlNode node) {
    final regex = RegExp(r'\s+');

    return node.innerText.replaceAll(regex, ' ');
  }

  String _getScript(XmlElement node) {
    final regex = RegExp(r'\s+');

    return node.innerText.replaceAll(regex, ' ');
  }
}
