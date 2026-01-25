import 'package:fpdart/fpdart.dart';
import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, List<Profile>>> getUsersByRole(String role);
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllCourses();
  Future<Either<Failure, List<Map<String, dynamic>>>> getCourseSections(int courseId);
  Future<Either<Failure, void>> assignStudentToSection({required String studentId, required int sectionId});
  Future<Either<Failure, void>> assignLecturerToSection({required String lecturerId, required int sectionId});
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserEnrollments(String userId, String role);
}
