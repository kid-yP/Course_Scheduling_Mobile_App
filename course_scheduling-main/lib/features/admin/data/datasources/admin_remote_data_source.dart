import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class AdminRemoteDataSource {
  Future<List<Map<String, dynamic>>> getUsersByRole(String role);
  Future<List<Map<String, dynamic>>> getAllCourses();
  Future<List<Map<String, dynamic>>> getCourseSections(int courseId);
  Future<void> assignStudentToSection({required String studentId, required int sectionId});
  Future<void> assignLecturerToSection({required String lecturerId, required int sectionId});
  Future<List<Map<String, dynamic>>> getUserEnrollments(String userId, String role);
}

class AdminRemoteDataSourceImpl implements AdminRemoteDataSource {
  final SupabaseClient supabaseClient;

  AdminRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<Map<String, dynamic>>> getUsersByRole(String role) async {
    try {
      final response = await supabaseClient
          .from('profiles')
          .select()
          .eq('role', role);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch $role: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAllCourses() async {
    try {
      final response = await supabaseClient.from('courses').select();
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch courses: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getCourseSections(int courseId) async {
    try {
      final response = await supabaseClient
          .from('sections')
          .select()
          .eq('course_id', courseId);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch sections: $e');
    }
  }

  @override
  Future<void> assignStudentToSection({required String studentId, required int sectionId}) async {
    try {
      await supabaseClient.from('enrollments').insert({
        'student_id': studentId,
        'section_id': sectionId,
      });
    } catch (e) {
      throw Exception('Failed to assign student: $e');
    }
  }

  @override
  Future<void> assignLecturerToSection({required String lecturerId, required int sectionId}) async {
    try {
      await supabaseClient.from('lecturer_assignments').insert({
        'lecturer_id': lecturerId,
        'section_id': sectionId,
      });
    } catch (e) {
      throw Exception('Failed to assign lecturer: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getUserEnrollments(String userId, String role) async {
    try {
      if (role == 'student') {
        final response = await supabaseClient
            .from('enrollments')
            .select('''
              sections (
                courses (name, code),
                section_name
              )
            ''')
            .eq('student_id', userId);
        return List<Map<String, dynamic>>.from(response);
      } else {
        final response = await supabaseClient
            .from('lecturer_assignments')
            .select('''
               sections (
                courses (name, code),
                section_name
              )
            ''')
            .eq('lecturer_id', userId);
        return List<Map<String, dynamic>>.from(response);
      }
    } catch (e) {
      throw Exception('Failed to fetch enrollments: $e');
    }
  }
}
