import 'package:flutter/material.dart';

class ClassItem {
  final String day; // e.g., "Monday"
  final int startHour; // e.g., 9
  final int endHour; // e.g., 11
  final String title; // e.g., "Math"
  final Color color;
  final String code;
  final String lecturer;
  final String room;
  // e.g., Colors.blue

  ClassItem({
    required this.lecturer,
    required this.room,
    required this.code,
    required this.day,
    required this.startHour,
    required this.endHour,
    required this.title,
    required this.color,
  });
}
