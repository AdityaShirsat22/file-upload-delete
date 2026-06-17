import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploadfile/data/models/model.dart';
import 'package:uploadfile/data/repo/file_repo.dart';

class FileViewModel extends StateNotifier<bool> {
  final FileRepository repository;

  FileViewModel(this.repository) : super(false);

  Future<void> uploadFile(File file) async {
    state = true;

    try {
      await repository.uploadFile(file);
    } finally {
      state = false;
    }
  }

  Future<void> deleteFile(FileModel file) async {
    await repository.deleteFile(file);
  }
}
