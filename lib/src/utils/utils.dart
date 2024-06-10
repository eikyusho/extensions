// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:meta/meta.dart';

@internal
int bytesToInt(Uint8List bytes) {
  return ByteData.view(bytes.buffer).getInt32(0, Endian.little);
}

@internal
Uint8List intToBytes(int value) {
  final bytes = Uint8List(4);
  ByteData.view(bytes.buffer).setInt32(0, value, Endian.little);
  return bytes;
}

@internal
int findHeaderIndex(List<int> mainList, List<int> header, [int start = 0]) {
  for (var i = start; i <= mainList.length - header.length; i++) {
    if (mainList.sublist(i, i + header.length).toString() ==
        header.toString()) {
      return i;
    }
  }
  return -1;
}

String removeDoubleSlash(String url) {
  return url.replaceAll(RegExp('(?<!:)/{2,}'), '/');
}
