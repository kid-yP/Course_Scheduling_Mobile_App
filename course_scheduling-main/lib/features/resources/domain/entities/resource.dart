class Resource {
  final int id;
  final int courseId;
  final int sectionId;
  final String uploadedBy; // Lecturer ID
  final String fileName;
  final String fileUrl;
  final String? description;
  final DateTime uploadedAt;

  Resource({
    required this.id,
    required this.courseId,
    required this.sectionId,
    required this.uploadedBy,
    required this.fileName,
    required this.fileUrl,
    this.description,
    required this.uploadedAt,
  });
}
