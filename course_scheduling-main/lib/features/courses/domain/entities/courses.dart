// domain/entities/courses.dart

class Courses {
  final List<Course> courses;
  Courses({required this.courses});
}

class Course {
  final int id;
  final String name;
  final String code;
  final List<String> lecturers;
  final List<CourseSchedule> schedule;
  final int sectionId;


  Course({
    required this.id,
    required this.name,
    required this.code,
    required this.lecturers,
    required this.schedule,
    required this.sectionId,
  });
}

class CourseSchedule {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String location;
  final String lecturer;

  CourseSchedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lecturer,
  });
}
