import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uploadfile/data/models/model.dart';
import 'package:uploadfile/providers/providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  Future<void> pickAndUpload(WidgetRef ref) async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) return;

    final file = File(result.files.single.path!);

    await ref.read(fileViewModelProvider.notifier).uploadFile(file);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(fileViewModelProvider);

    final repository = ref.read(fileRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("File Manager")),
      floatingActionButton: FloatingActionButton(
        onPressed: () => pickAndUpload(ref),
        child: const Icon(Icons.upload),
      ),
      body: Stack(
        children: [
          StreamBuilder<List<FileModel>>(
            stream: repository.getFiles(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final files = snapshot.data!;

              if (files.isEmpty) {
                return const Center(child: Text("No Files"));
              }

              return ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, index) {
                  final file = files[index];

                  return ListTile(
                    leading: const Icon(Icons.insert_drive_file),
                    title: Text(file.fileName),
                    subtitle: Text(file.fileType),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        ref
                            .read(fileViewModelProvider.notifier)
                            .deleteFile(file);
                      },
                    ),
                  );
                },
              );
            },
          ),
          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
