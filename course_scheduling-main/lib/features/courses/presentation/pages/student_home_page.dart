import 'package:course_scheduling/features/courses/presentation/pages/map_courses_to_classes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:course_scheduling/features/courses/presentation/bloc/student_courses_bloc.dart';
import 'package:course_scheduling/features/courses/presentation/pages/student_home_content.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
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
                Icons.calendar_today_outlined,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Weekly Schedule",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "Your weekly class schedule",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ],
        ),
      ),
      body: BlocBuilder<StudentCoursesBloc, StudentCoursesState>(
        builder: (context, state) {
          if (state is StudentCoursesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is StudentCoursesError) {
            return Center(child: Text(state.message));
          }

          if (state is StudentCoursesLoaded) {
            final classes = mapCoursesToClasses(state.courses);

            return StudentHomeContent(classes: classes);
          }

          return const SizedBox();
        },
      ),
    );
  }
}
