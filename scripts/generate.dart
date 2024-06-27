import 'dart:convert';
import 'dart:io';

import 'package:eikyusho_extensions/extensions.dart';
import 'package:eikyusho_extensions/src/core/languages.dart';
import 'package:eikyusho_extensions/src/utils/logger.dart';
import 'package:uuid/uuid.dart';

class JsonMap {
  JsonMap(this.file) {
    final jsonContent = jsonDecode(file.readAsStringSync()) as List<dynamic>;
    _map = jsonContent.map((e) => e as Map<String, dynamic>).toList();
  }

  final File file;
  late final List<Map<String, dynamic>> _map;

  bool containsDirectory(String directory) {
    return _map.any((element) => element['src'] == directory);
  }

  bool containsDirectoryAndLanguage(String directory, String language) {
    return _map.any(
      (element) {
        return element['src'] == directory && element['language'] == language;
      },
    );
  }

  bool containsWithSameVersion(
    String directory,
    String language,
    String version,
  ) {
    return _map.any(
      (element) {
        return element['src'] == directory &&
            element['language'] == language &&
            element['version'] == version;
      },
    );
  }

  void add(Map<String, dynamic> map) {
    _map.add(map);
    _saveToFile();
  }

  void update(Map<String, dynamic> map) {
    final index = _map.indexWhere((element) => element['src'] == map['src']);
    _map[index] = map;
    _saveToFile();
  }

  String getFileUuid(String path) {
    final index = _map.where((element) => element['src'] == path);
    return index.first['uuid'] as String;
  }

  void _saveToFile() {
    final jsonString = jsonEncode(_map);
    file.writeAsStringSync(jsonString);
  }
}

final jsonMap = JsonMap(File('index.min.json'));
const compiler = EikyushoCompiler();

void main() {
  final srcDir = Directory('src');

  final languageDirs = srcDir.listSync().whereType<Directory>();

  for (final langDir in languageDirs) {
    final directories = langDir.listSync().whereType<Directory>();

    for (final dir in directories) {
      generateExtensions(dir.path);
    }
  }
}

void generateExtensions(String path) {
  final binDir = Directory('bin');

  final iconFile = File('$path/${Constants.imgFile}');
  final xmlFile = File('$path/${Constants.xmlFile}');

  if (!iconFile.existsSync() && !xmlFile.existsSync()) {
    AppLogger.warning('Skipping $path...');
    return;
  }

  final source = EikyushoParser(xmlFile.readAsStringSync());

  Language.validate(source.language);

  final (exists, version) = verifyExistence(path, source);

  if (!exists && version == null) {
    return createSourceFile(binDir, xmlFile, iconFile);
  }

  if (exists && version != null) {
    return updateSourceFile(binDir, xmlFile, iconFile);
  }
}

(bool, String?) verifyExistence(String path, EikyushoParser source) {
  final isAlreadyCompiled = jsonMap.containsDirectory(path);

  if (!isAlreadyCompiled) return (false, null);

  final hasTheSameLanguage = jsonMap.containsDirectoryAndLanguage(
    path,
    source.language,
  );

  if (!hasTheSameLanguage) return (false, null);

  final hasTheSameVersion = jsonMap.containsWithSameVersion(
    path,
    source.language,
    source.version,
  );

  if (hasTheSameVersion) return (true, null);

  return (true, source.version);
}

void createSourceFile(Directory bin, File source, File iconFile) {
  final uuid = const Uuid().v4();

  Directory('${bin.path}/$uuid').createSync();

  final eksFile = '${bin.path}/$uuid/${Constants.eksFile}';

  compiler.encode(source.path, iconFile.path, eksFile);

  iconFile.copy('${bin.path}/$uuid/icon-preview${Constants.imgExtension}');

  addJsonMap(
    source.parent.path,
    EikyushoParser(source.readAsStringSync()),
    uuid,
  );
}

void updateSourceFile(Directory bin, File source, File iconFile) {
  final uuid = jsonMap.getFileUuid(source.parent.path);

  final eksFile = '${bin.path}/$uuid/${Constants.eksFile}';

  compiler.encode(source.path, iconFile.path, eksFile);

  updateJsonMap(
    source.parent.path,
    EikyushoParser(source.readAsStringSync()),
    uuid,
  );
}

void addJsonMap(String path, EikyushoParser source, String uuid) {
  final map = {
    'uuid': uuid,
    'name': source.name,
    'icon': Constants.imgFile,
    'language': source.language,
    'version': source.version,
    'src': path,
  };

  jsonMap.add(map);
}

void updateJsonMap(String path, EikyushoParser source, String uuid) {
  final map = {
    'uuid': uuid,
    'name': source.name,
    'icon': Constants.imgFile,
    'language': source.language,
    'version': source.version,
    'src': path,
  };

  jsonMap.update(map);
}
