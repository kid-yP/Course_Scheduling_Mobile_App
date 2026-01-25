import '../../domain/entities/courses.dart';
import 'course_model.dart';

class CoursesModel {
  final List<CourseModel> courses;

  CoursesModel({required this.courses});

  Courses toEntity() {
    return Courses(
      courses: courses.map((c) => c.toEntity()).toList(),
    );
  }
}
