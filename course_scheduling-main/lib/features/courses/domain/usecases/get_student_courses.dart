import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/core/usecase/usecase.dart';
import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:course_scheduling/features/courses/domain/repository/courses_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetStudentCourses implements UseCase<Courses, GetStudentCoursesParams> {
  final CoursesRepository coursesRepository;
  const GetStudentCourses(this.coursesRepository);


  @override
  Future<Either<Failure, Courses>> call(GetStudentCoursesParams params) async {
    return await coursesRepository.getStudentCourses(userId: params.userId);
  }
}

class GetStudentCoursesParams {
  final String userId;
  GetStudentCoursesParams({required this.userId});
}
