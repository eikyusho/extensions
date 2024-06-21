// ignore_for_file: public_member_api_docs

import 'package:meta/meta.dart';

/// A class that contains all the constants used in the package.
final class Constants {
  const Constants._();

  @internal
  static final xmlHeader = '[XML_HEADER]'.codeUnits;
  @internal
  static final imgHeader = '[IMG_HEADER]'.codeUnits;
  @internal
  static const headerOffset = 4;

  @internal
  static const imgExtension = '.png';

  /// Eikyusho binary extension.
  static const eksFile = 'source.eks';

  /// Eikyusho XML extension.
  static const xmlFile = 'source.xml';

  /// Eikyusho image extension.
  static const imgFile = 'icon$imgExtension';
  static const imgPreviewFile = 'icon-preview$imgExtension';

  static const img1xFile = 'icon@1x$imgExtension';
  static const img2xFile = 'icon@2x$imgExtension';
  static const img3xFile = 'icon@3x$imgExtension';
}
