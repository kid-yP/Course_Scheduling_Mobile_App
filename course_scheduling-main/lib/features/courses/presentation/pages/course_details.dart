import 'package:course_scheduling/features/chat/presentation/pages/chat_page.dart';
import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:course_scheduling/features/resources/presentation/pages/resource_page.dart';
import 'package:course_scheduling/widgets/course_details_card.dart';
import 'package:flutter/material.dart';

class CourseDetails extends StatelessWidget {
  final Course course;
  final String userId;
  const CourseDetails({super.key, required this.course, required this.userId});

  @override
  Widget build(BuildContext context) {
    String courseCode = course.code;
    String courseName = course.name;
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

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "$courseCode",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 4),

                Text(
                  "$courseName",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
      body: Container(
          child: Column(
            children: [

              CourseDetailsCard(icon: Icons.chat, title: "Course Chat", subtitle: "Discuss with classmate and instructor", iconColor: Colors.blue,onTap: (){Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage(courseId: course.id, sectionId: course.sectionId, userId: userId),
                        ),
                      );}),
              CourseDetailsCard(icon: Icons.file_download, title: "Resources", subtitle: "Access PDFs, images, and materials",iconColor:  Colors.green, onTap: (){Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResourcePage(
                            courseId: course.id,
                            sectionId: course.sectionId,
                            userId: userId,
                            userRole: 'student',
                          ),
                        ),
                      );})
            ]

          ),
        )
    );
  }
}
