part of 'admin_bloc.dart';

@immutable
sealed class AdminEvent {}

class FetchStudents extends AdminEvent {}

class FetchLecturers extends AdminEvent {}

class FetchEnrollments extends AdminEvent {
  final String userId;
  final String role;
  FetchEnrollments({required this.userId, required this.role});
}

class FetchAllCourses extends AdminEvent {}

class FetchCourseSections extends AdminEvent {
  final int courseId;
  FetchCourseSections({required this.courseId});
}

class AssignStudent extends AdminEvent {
  final String studentId;
  final int sectionId;
  AssignStudent({required this.studentId, required this.sectionId});
}

class AssignLecturer extends AdminEvent {
  final String lecturerId;
  final int sectionId;
  AssignLecturer({required this.lecturerId, required this.sectionId});
}

class ClearAdminMessages extends AdminEvent {}
