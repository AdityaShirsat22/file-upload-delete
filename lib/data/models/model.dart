class FileModel {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;

  FileModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
  });

  factory FileModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FileModel(
      id: json['id'],
      fileName: json['file_name'],
      fileUrl: json['file_url'],
      fileType: json['file_type'],
    );
  }
}