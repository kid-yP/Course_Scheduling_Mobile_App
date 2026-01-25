import 'package:course_scheduling/features/resources/domain/entities/resource.dart';

class ResourceModel extends Resource {
  ResourceModel({
    required super.id,
    required super.courseId,
    required super.sectionId,
    required super.uploadedBy,
    required super.fileName,
    required super.fileUrl,
    super.description,
    required super.uploadedAt,
  });

  factory ResourceModel.fromJson(Map<String, dynamic> json) {
    return ResourceModel(
      id: json['id'] as int,
      courseId: json['course_id'] as int,
      sectionId: json['section_id'] as int,
      uploadedBy: json['uploaded_by'] as String,
      fileName: json['file_name'] as String,
      fileUrl: json['file_url'] as String,
      description: json['description'] as String?,
      uploadedAt: DateTime.parse(json['uploaded_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'section_id': sectionId,
      'uploaded_by': uploadedBy,
      'file_name': fileName,
      'file_url': fileUrl,
      'description': description,
      'uploaded_at': uploadedAt.toIso8601String(),
    };
  }
}
