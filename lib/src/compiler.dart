import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart';
import 'package:meta/meta.dart';
import 'package:path/path.dart' as path;

import 'constants/constants.dart';
import 'enums/enums.dart';
import 'utils/utils.dart';

/// A class that compiles an Eikyusho file.
final class EikyushoCompiler {
  /// Creates a new instance of [EikyushoCompiler].
  const EikyushoCompiler();

  @internal
  /// Encodes the Eikyusho file.
  Future<void> encode(String xmlFile, String imagePath, String eksFile) async {
    final xmlData = _readFile(xmlFile);
    final images = <Uint8List>[];

    final icon1x = _generateIconPack(imagePath, PixelDensity.x1);
    final icon2x = _generateIconPack(imagePath, PixelDensity.x2);
    final icon3x = _generateIconPack(imagePath, PixelDensity.x3);

    for (final icon in [icon1x, icon2x, icon3x]) {
      images.add(encodePng(await icon));
    }

    await _writeEks(xmlData, images, eksFile);
  }

  /// Decodes the Eikyusho file.
  Future<void> decode(String savePath, Uint8List data) async {
    final (xmlData, xmlEnd) = _readEks(data, Constants.xmlHeader, 0);
    final (img1xData, imgx1End) = _readEks(data, Constants.imgHeader, xmlEnd);
    final (img2xData, imgx2End) = _readEks(data, Constants.imgHeader, imgx1End);
    final (img3xData, _) = _readEks(data, Constants.imgHeader, imgx2End);

    await _writeFile(xmlData, path.join(savePath, Constants.xmlFile));
    await _writeFile(img1xData, path.join(savePath, Constants.img1xFile));
    await _writeFile(img2xData, path.join(savePath, Constants.img2xFile));
    await _writeFile(img3xData, path.join(savePath, Constants.img3xFile));
  }

  Future<Image> _generateIconPack(
    String path,
    PixelDensity pixelDensity,
  ) async {
    final data = await _readFileAsync(path);

    final src = decodeImage(data);

    if (src == null) throw Exception('Failed to read image file');

    final (width, height) = pixelDensity.size(src.width, src.height);

    return copyResize(
      src,
      width: width,
      height: height,
      interpolation: Interpolation.average,
    );
  }

  Future<void> _writeFile(Uint8List content, String path) async {
    await File(path).writeAsBytes(content);
  }

  Future<Uint8List> _readFileAsync(String path) async {
    return File(path).readAsBytes();
  }

  Uint8List _readFile(String path) {
    final content = File(path).readAsStringSync();

    return utf8.encode(content);
  }

  Future<void> _writeEks(
    Uint8List xml,
    List<Uint8List> images,
    String eksFile,
  ) async {
    final eksData = <int>[
      ..._writeHeader(Constants.xmlHeader, xml.length),
      ...xml,
    ];

    for (final image in images) {
      eksData
        ..addAll(_writeHeader(Constants.imgHeader, image.length))
        ..addAll(image);
    }

    await File(eksFile).writeAsBytes(eksData);
  }

  (Uint8List, int) _readEks(Uint8List data, List<int> header, int start) {
    final mainList = data.sublist(start);

    final headerIndex = findHeaderIndex(mainList, header);

    if (headerIndex == -1) throw Exception('Invalid eks file');

    final headerContentLength = headerIndex + header.length;
    final headerLength = headerContentLength + Constants.headerOffset;

    final fileBytes = bytesToInt(
      mainList.sublist(headerContentLength, headerLength),
    );
    final fileLength = headerLength + fileBytes;

    return (mainList.sublist(headerLength, fileLength), fileLength);
  }

  List<int> _writeHeader(List<int> header, int value) {
    return [...header, ...intToBytes(value)];
  }
}
