import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class CoursesRepository {
  Future<Either<Failure, Courses>> getStudentCourses({
    required String userId,
  });
}
