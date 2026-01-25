import '../../domain/entities/courses.dart';

class CourseScheduleModel {
  final int dayOfWeek;
  final String startTime;
  final String endTime;
  final String location;
  final String lecturer;

  CourseScheduleModel({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.lecturer,
  });

  CourseSchedule toEntity() {
    return CourseSchedule(
      dayOfWeek: dayOfWeek,
      startTime: startTime,
      endTime: endTime,
      location: location,
      lecturer: lecturer,
    );
  }
}
