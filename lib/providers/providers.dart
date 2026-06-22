import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploadfile/data/models/model.dart';
import 'package:uploadfile/data/repo/file_repo.dart';
import 'package:uploadfile/view_models/controller.dart';

final fileRepositoryProvider = Provider<FileRepository>((ref) => FileRepository(),);

final fileViewModelProvider = AsyncNotifierProvider<FileViewModel, void>(
  FileViewModel.new,
);

final filesProvider = StreamProvider<List<FileModel>>((ref) {
  return ref.watch(fileRepositoryProvider).getFiles();
});
