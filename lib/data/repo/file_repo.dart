import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uploadfile/data/models/model.dart';

class FileRepository {
  final FirebaseFirestore firestore;
  final FirebaseStorage storage;

  FileRepository({required this.firestore, required this.storage});

  Future<void> uploadFile(File file) async {
    try {
      final fileName = file.path.split('/').last;

      print("Uploading: $fileName");

      final ref = storage.ref().child("uploads/$fileName");

      final task = await ref.putFile(file);

      print("Upload Success");

      final url = await ref.getDownloadURL();

      print("URL: $url");

      await firestore.collection("files").add({
        "fileName": fileName,
        "fileUrl": url,
        "uploadedAt": DateTime.now().toIso8601String(),
      });

      print("Firestore Saved");
    } catch (e) {
      print("UPLOAD ERROR => $e");
    }
  }

  Stream<List<FileModel>> getFiles() {
    return firestore
        .collection('files')
        .orderBy('uploadedAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return FileModel.fromMap(doc.id, doc.data());
          }).toList();
        });
  }

  Future<void> deleteFile(FileModel file) async {
    try {
      await storage.refFromURL(file.fileUrl).delete();

      await firestore.collection('files').doc(file.id).delete();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
