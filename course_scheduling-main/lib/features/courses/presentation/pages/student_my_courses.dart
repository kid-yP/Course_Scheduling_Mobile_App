import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:course_scheduling/features/courses/presentation/pages/course_details.dart';
import 'package:course_scheduling/features/courses/presentation/pages/student_home_page.dart';
import 'package:course_scheduling/widgets/course_card.dart';
import 'package:flutter/material.dart';

class StudentMyCourses extends StatelessWidget {
  final Courses courses;
  final String userId;
  final Future<void> Function() onRefresh;
  const StudentMyCourses({super.key, required this.courses, required this.userId, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    int num_courses = courses.courses.length;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 110,
        elevation: 4,
        backgroundColor: Colors.transparent,

        centerTitle: false,

        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade200, Colors.blue.shade700],
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
        ),

        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.25),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.menu_book_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "My Courses",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "You are enrolled in $num_courses Courses",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: ListView.builder(
                  itemCount: courses.courses.length,
                  itemBuilder: (contex, index) {
                    final course = courses.courses[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseDetails(course: course, userId: userId,),
                          ),
                        );
                      },
                      child: CourseCard(
                        lecturer: course.lecturers[0],
                        courseName: course.name,
                        courseNumber: course.code,
                        color: Colors.blue,
                      ),
                    );
                  },
                ),
              ),
            ),
            // CourseCard(
            //   lecturer: 'Dr kebede',
            //   room: 'Room 2001',
            //   courseName: 'Physics',
            //   courseNumber: 'cs231',
            //   numberOfStudent: '234',
            //   color: Colors.blue,
            // ),
          ],
        ),
      ),
    );
  }
}
