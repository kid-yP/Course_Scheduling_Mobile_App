part of 'resource_bloc.dart';

@immutable
sealed class ResourceEvent {}

class LoadResources extends ResourceEvent {
  final int courseId;
  final int sectionId;

  LoadResources({required this.courseId, required this.sectionId});
}

class UploadResourceEvent extends ResourceEvent {
  final int courseId;
  final int sectionId;
  final String uploadedBy;
  final File file;
  final String fileName;
  final String description;

  UploadResourceEvent({
    required this.courseId,
    required this.sectionId,
    required this.uploadedBy,
    required this.file,
    required this.fileName,
    required this.description,
  });
}
