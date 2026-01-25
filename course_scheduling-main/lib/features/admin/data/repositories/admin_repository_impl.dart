import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:course_scheduling/features/admin/domain/repositories/admin_repository.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Profile>>> getUsersByRole(String role) async {
    try {
      final result = await remoteDataSource.getUsersByRole(role);
      final profiles = result.map((e) => Profile(
        userId: e['id'],
        role: e['role'],
        name: e['username'] ?? e['email'], // Fallback if username is missing?
      )).toList();
      return right(profiles);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getAllCourses() async {
    try {
      final result = await remoteDataSource.getAllCourses();
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getCourseSections(int courseId) async {
    try {
      final result = await remoteDataSource.getCourseSections(courseId);
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> assignStudentToSection({required String studentId, required int sectionId}) async {
    try {
      await remoteDataSource.assignStudentToSection(studentId: studentId, sectionId: sectionId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> assignLecturerToSection({required String lecturerId, required int sectionId}) async {
    try {
      await remoteDataSource.assignLecturerToSection(lecturerId: lecturerId, sectionId: sectionId);
      return right(null);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getUserEnrollments(String userId, String role) async {
    try {
      final result = await remoteDataSource.getUserEnrollments(userId, role);
      return right(result);
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
