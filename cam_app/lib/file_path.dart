import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FileDirectoryAdapter {
  static Future<void> saveImage(File imageFile) async {
    Directory docDir = await getApplicationDocumentsDirectory();
    Directory imgDir = Directory('${docDir.path}/gallary');
    if (!imgDir.existsSync()) {
      imgDir.createSync(
        recursive: true,
      );
    }
    await imageFile.copy(
      '${imgDir.path}/${DateTime.now().millisecondsSinceEpoch.toString()}.jpg',
    );
  }

  static Future<List<String>> getImages() async {
    try {
      Directory docDir = await getApplicationDocumentsDirectory();
      Directory imgDir = Directory('${docDir.path}/gallary');
      List<FileSystemEntity> files = imgDir.listSync();
      List<FileSystemEntity> fileList =files
          .where(
            (file) => file is File && file.path.toLowerCase().endsWith('.jpg'),
          ).toList();
      List<String> imagePaths = fileList
          .map(
            (file) => file.path,
          )
          .toList();
      return imagePaths;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static void deleteElementByPath(String path) {
    FileSystemEntity fileEntity = File(path);
    if (fileEntity.existsSync()) {
      if (fileEntity is File) {
        fileEntity.deleteSync();
      } else if (fileEntity is Directory) {
        fileEntity.deleteSync(
          recursive: true,
        );
      }
    }
  }
}