import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:flutter/material.dart';

class ScheduleItemModel extends ScheduleItem {
  ScheduleItemModel({
    required super.id,
    required super.courseId,
    required super.sectionId,
    required super.lecturerId,
    required super.dayOfWeek,
    required super.startTime,
    required super.endTime,
    required super.location,
    super.courseName,
    super.sectionName,
  });

  factory ScheduleItemModel.fromJson(Map<String, dynamic> json) {
    return ScheduleItemModel(
      id: json['id'] as int,
      courseId: json['course_id'] as int,
      sectionId: json['section_id'] as int,
      lecturerId: json['lecturer_id'] as String,
      dayOfWeek: json['day_of_week'] as int,
      startTime: _parseTime(json['start_time'] as String),
      endTime: _parseTime(json['end_time'] as String),
      location: json['location'] as String,
      courseName: json['courses'] != null ? json['courses']['name'] : null,
      sectionName: json['sections'] != null ? json['sections']['name'] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'section_id': sectionId,
      'lecturer_id': lecturerId,
      'day_of_week': dayOfWeek,
      'start_time': _formatTime(startTime),
      'end_time': _formatTime(endTime),
      'location': location,
    };
  }

  static TimeOfDay _parseTime(String timeStr) {
    // Format "HH:mm:ss" or "HH:mm"
    final parts = timeStr.split(':');
    return TimeOfDay(
      hour: int.parse(parts[0]),
      minute: int.parse(parts[1]),
    );
  }

  static String _formatTime(TimeOfDay time) {
    // Returns HH:mm:00
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }
}
