import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uploadfile/data/repo/file_repo.dart';
import 'package:uploadfile/view_models/controller.dart';


final firestoreProvider =
    Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final storageProvider =
    Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
);

final fileRepositoryProvider =
    Provider<FileRepository>(
  (ref) {
    return FileRepository(
      firestore:
          ref.read(firestoreProvider),
      storage:
          ref.read(storageProvider),
    );
  },
);

final fileViewModelProvider =
    StateNotifierProvider<
        FileViewModel,
        bool>(
  (ref) {
    return FileViewModel(
      ref.read(
          fileRepositoryProvider),
    );
  },
);