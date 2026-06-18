import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uploadfile/data/models/model.dart';

class FileRepository {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<void> uploadFile(File file) async {
    try {
      print("STEP 1: Upload Started");

      final timestamp = DateTime.now().millisecondsSinceEpoch;

      final extension = file.path.split('.').last;

      final storageName = "$timestamp.$extension";

      print("STEP 2: $storageName");

      await _supabase.storage.from('uploads').upload(storageName, file);

      print("STEP 3: Storage Upload Success");

      final url = _supabase.storage.from('uploads').getPublicUrl(storageName);

      print("STEP 4: URL = $url");

      await _supabase.from('files').insert({
        'file_name': file.path.split('/').last,
        'file_url': url,
        'file_type': extension,
      });

      print("STEP 5: Database Insert Success");
    } catch (e, s) {
      print("ERROR => $e");
      print(s);
    }
  }

  Stream<List<FileModel>> getFiles() {
    return _supabase.from('files').stream(primaryKey: ['id']).map((data) {
      final unique = <String, FileModel>{};

      for (final item in data) {
        final model = FileModel.fromJson(item);

        unique[model.id] = model;
      }

      return unique.values.toList();
    });
  }

  Future<void> deleteFile(FileModel file) async {
    try {
      print("DELETE STEP 1");

      final storageFileName = file.fileUrl.split('/').last;

      print("DELETE STEP 2: $storageFileName");

      await _supabase.storage.from('uploads').remove([storageFileName]);

      print("DELETE STEP 3: Storage Deleted");

      await _supabase.from('files').delete().eq('id', file.id);

      print("DELETE STEP 4: DB Deleted");
    } catch (e, s) {
      print("DELETE ERROR => $e");
      print(s);
    }
  }
}
