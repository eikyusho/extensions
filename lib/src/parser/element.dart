import 'package:meta/meta.dart';

@immutable
/// Represents an element in the XML document.
class Element {
  /// Creates a new instance of [Element].
  const Element({required this.selector, required this.attribute});

  /// The selector of the element.
  final String selector;

  /// The attribute of the element.
  final String? attribute;

  /// Converts the [Element] to a string.
  @override
  String toString() {
    return '(selector: $selector, attribute: $attribute)';
  }
}
