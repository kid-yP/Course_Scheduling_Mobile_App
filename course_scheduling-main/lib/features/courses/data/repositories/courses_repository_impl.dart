import 'package:course_scheduling/core/error/exceptions.dart';
import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:course_scheduling/features/courses/domain/repository/courses_repository.dart';
import 'package:fpdart/fpdart.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesRemoteDataSource remoteDataSource;
  const CoursesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, Courses>> getStudentCourses({
    required String userId,
  }) async {
    try {
      final coursesModel = await remoteDataSource.getStudentCourses(
        userId: userId,
      );
      final coursesEntiny = coursesModel.toEntity();
      return right(coursesEntiny);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
