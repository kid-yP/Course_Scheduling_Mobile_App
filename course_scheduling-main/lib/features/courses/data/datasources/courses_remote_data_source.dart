import 'package:course_scheduling/features/courses/data/models/course_model.dart';
import 'package:course_scheduling/features/courses/data/models/course_schedule_model.dart';
import 'package:course_scheduling/features/courses/data/models/courses_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class CoursesRemoteDataSource {
  Future<CoursesModel> getStudentCourses({required String userId});
}

class CourseRemoteDataSourceImpl implements CoursesRemoteDataSource {
  final SupabaseClient supabaseClient;

  CourseRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<CoursesModel> getStudentCourses({required String userId}) async {
    try {
      final response = await supabaseClient
          .from('enrollments')
          .select('''
            sections (
              id,
              courses (
                id,
                name,
                code
              ),
              lecturer_assignments (
                profiles (
                  username
                )
              ),
              weekly_schedule (
                day_of_week,
                start_time,
                end_time,
                location,
                profiles (
                  username
                )
              )
            )
          ''')
          .eq('student_id', userId);

      final Map<int, CourseModel> courseMap = {};

      for (final row in response) {
        final section = row['sections'];
        final course = section['courses'];

        final int courseId = course['id'];
        final int sectionId = section['id'];

        courseMap.putIfAbsent(
          courseId,
          () => CourseModel(
            id: courseId,
            name: course['name'],
            code: course['code'],
            lecturers: [],
            schedule: [],
            sectionId: sectionId,
          ),
        );

        // lecturers
        for (final la in section['lecturer_assignments']) {
          final lecturerName = la['profiles']['username'];
          if (!courseMap[courseId]!.lecturers.contains(lecturerName)) {
            courseMap[courseId]!.lecturers.add(lecturerName);
          }
        }

        // schedule
        for (final ws in section['weekly_schedule']) {
          courseMap[courseId]!.schedule.add(
            CourseScheduleModel(
              dayOfWeek: ws['day_of_week'],
              startTime: ws['start_time'],
              endTime: ws['end_time'],
              location: ws['location'],
              lecturer: ws['profiles']['username'],
            ),
          );
        }
      }

      return CoursesModel(courses: courseMap.values.toList());
    } catch (e) {
      throw Exception('Failed to fetch student courses: $e');
    }
  }
}

