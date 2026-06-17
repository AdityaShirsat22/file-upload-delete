class FileModel {
  final String id;
  final String fileName;
  final String fileUrl;
  final String fileType;
  final DateTime uploadedAt;

  FileModel({
    required this.id,
    required this.fileName,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedAt,
  });

  factory FileModel.fromMap(String id, Map<String, dynamic> map) {
    return FileModel(
      id: id,
      fileName: map['fileName'] ?? '',
      fileUrl: map['fileUrl'] ?? '',
      fileType: map['fileType'] ?? '',
      uploadedAt: DateTime.parse(map['uploadedAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'fileName': fileName,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'uploadedAt': uploadedAt.toIso8601String(),
    };
  }
}
