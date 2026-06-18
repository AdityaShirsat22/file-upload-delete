import 'dart:async';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploadfile/data/models/model.dart';
import 'package:uploadfile/data/repo/file_repo.dart';
import 'package:uploadfile/providers/providers.dart';

class FileViewModel extends AsyncNotifier<void> {
  late final FileRepository repository;

  @override
  FutureOr<void> build() {
    repository = ref.read(fileRepositoryProvider);
  }

  Future<void> upload(File file) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.uploadFile(file);
    });
  }

  Future<void> delete(FileModel file) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      await repository.deleteFile(file);

      ref.invalidate(filesProvider);
    });
  }
}
