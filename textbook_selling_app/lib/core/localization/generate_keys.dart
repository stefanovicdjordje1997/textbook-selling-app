import 'dart:convert';
import 'dart:io';

import 'package:textbook_selling_app/core/constant/paths.dart';

void main() async {
  const inputFilePath = Paths.englishLang;
  const outputFilePath = Paths.localKeys;

  final file = File(inputFilePath);
  final jsonContent =
      json.decode(await file.readAsString()) as Map<String, dynamic>;

  final buffer = StringBuffer()
    ..writeln("class LocalKeys {")
    ..writeAll(
      jsonContent.keys.map((key) => "  static const $key = '$key';\n"),
    )
    ..writeln("}");

  final outputFile = File(outputFilePath);
  await outputFile.writeAsString(buffer.toString());

  print('Generated LocalKeys class successfully!');
}
