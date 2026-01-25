import '../../domain/entities/courses.dart';
import 'course_schedule_model.dart';

class CourseModel {
  final int id;
  final String name;
  final String code;
  final List<String> lecturers;
  final List<CourseScheduleModel> schedule;

  final int sectionId;

  CourseModel({
    required this.id,
    required this.name,
    required this.code,
    required this.lecturers,
    required this.schedule,
    required this.sectionId,
  });

  Course toEntity() {
    return Course(
      id: id,
      name: name,
      code: code,
      lecturers: lecturers,
      schedule: schedule.map((s) => s.toEntity()).toList(),
      sectionId: sectionId,
    );
  }
}
