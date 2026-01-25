import 'package:flutter/material.dart';

class ScheduleItem {
  final int id;
  final int courseId;
  final int sectionId;
  final String lecturerId;
  final int dayOfWeek; // 1 = Monday
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final String location;
  final String? courseName; // For display
  final String? sectionName; // For display

  ScheduleItem({
    required this.id,
    required this.courseId,
    required this.sectionId,
    required this.lecturerId,
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.location,
    this.courseName,
    this.sectionName,
  });
}
