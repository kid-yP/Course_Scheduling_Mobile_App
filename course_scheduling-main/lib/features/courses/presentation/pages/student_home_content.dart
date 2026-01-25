import 'package:course_scheduling/models/class.dart';
import 'package:course_scheduling/widgets/calander.dart';
import 'package:course_scheduling/widgets/tile.dart';
import 'package:flutter/material.dart';

class StudentHomeContent extends StatelessWidget {
  final List<ClassItem> classes;

  const StudentHomeContent({super.key, required this.classes});

  @override
  Widget build(BuildContext context) {
    // 1️⃣ Number of classes
    final int numberOfClasses = classes.length;

    // 2️⃣ Total hours
    final int totalHours = classes.fold(
      0,
      (sum, c) => sum + (c.endHour - c.startHour),
    );

    // 3️⃣ Number of unique courses
    final int numberOfCourses =
        classes.map((c) => c.code).toSet().length;

    // 4️⃣ Number of days with classes
    final int daysWithClasses =
        classes.map((c) => c.day).toSet().length;

    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1)),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Tile(
                      title: "Classes",
                      subTitle: "$numberOfClasses this week",
                      icon: Icons.menu_book_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Tile(
                      title: "Total Hours",
                      subTitle: "$totalHours hrs",
                      icon: Icons.schedule_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Tile(
                      title: "Courses",
                      subTitle: "$numberOfCourses courses",
                      icon: Icons.library_books_rounded,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Tile(
                      title: "Days",
                      subTitle: "$daysWithClasses days/week",
                      icon: Icons.calendar_today_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              WeeklyCalendar(classes: classes),
            ],
          ),
        ),
      ),
    );
  }
}
