import 'dart:convert';

import 'package:path_provider/path_provider.dart';
import 'dart:io';

class LocalFileUtility {


  static Future<String> getFilePath() async {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/JournalEntries.txt'; // 3
    print(filePath);
    return filePath;
  }

  static void saveFile(Map<String, Object?> json) async {
    File file = File(await getFilePath());
    String _jsonString = jsonEncode(json);
    print(_jsonString);
    file.writeAsString(_jsonString);

  }

  static Future<String> readFile() async {
    File file = File(await getFilePath());
    String fileContent = await file.readAsString();
    print('File Content: $fileContent');
    return fileContent;
  }

}


