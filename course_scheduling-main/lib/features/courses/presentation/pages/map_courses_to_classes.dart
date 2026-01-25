import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:course_scheduling/models/class.dart';
import 'package:flutter/material.dart';

List<ClassItem> mapCoursesToClasses(Courses courses) {
  final List<ClassItem> result = [];

  for (final course in courses.courses) {
    for (final schedule in course.schedule) {
      result.add(
        ClassItem(
          day: _dayFromInt(schedule.dayOfWeek),
          startHour: int.parse(schedule.startTime.split(':')[0]),
          endHour: int.parse(schedule.endTime.split(':')[0]),
          title: course.name,
          code: course.code,
          room: schedule.location,
          lecturer: schedule.lecturer,
          color: Colors.blue, // can be dynamic later
        ),
      );
    }
  }

  return result;
}

String _dayFromInt(int day) {
  switch (day) {
    case 1: return "Monday";
    case 2: return "Tuesday";
    case 3: return "Wednesday";
    case 4: return "Thursday";
    case 5: return "Friday";
    case 6: return "Saturday";
    case 7: return "Sunday";
    default: return "";
  }
}
