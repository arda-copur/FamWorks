import 'dart:io';
import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageNetworkClass {
  static Future<void> downloadAndSaveImage(String url, String filename) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final Uint8List bytes = response.bodyBytes;
      final Directory directory = await getApplicationDocumentsDirectory();
      final File file = File(path.join(directory.path, filename));
      await file.writeAsBytes(bytes);
    } else {
      throw Exception('Bir hata oluştu');
    }
  }

  static Future<ImageProvider> getImage(String url, String filename) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File(path.join(directory.path, filename));
    if (await file.exists()) {
      return FileImage(file);
    } else {
      await downloadAndSaveImage(url, filename);
      return FileImage(file);
    }
  }
}
