import 'dart:io';

import 'package:dio/dio.dart';

class DownloadService {
  static Future<String> downloadFile({
    required String url,
    required String fileName,
  }) async {
    Directory? downloadsDir;

    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    }
    final savePath = '${downloadsDir?.path}/$fileName';
    await Dio().download(
      url,
      savePath,
      onReceiveProgress: (received, total) {
        if (total != -1) {
          print("${((received / total) * 100).toStringAsFixed(0)}%");
        }
      },
    );
    print("File saved at: $savePath");

    final file = File(savePath);

    print("Exists: ${await file.exists()}");

    return savePath;
  }
}
