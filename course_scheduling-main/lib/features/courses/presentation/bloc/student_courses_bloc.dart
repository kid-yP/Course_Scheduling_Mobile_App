import 'package:flutter/material.dart';
import 'package:course_scheduling/features/courses/domain/entities/courses.dart';
import 'package:course_scheduling/features/courses/domain/usecases/get_student_courses.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'student_courses_event.dart';
part 'student_courses_state.dart';

class StudentCoursesBloc
    extends Bloc<StudentCoursesEvent, StudentCoursesState> {
  final GetStudentCourses _getStudentCourses;

  StudentCoursesBloc({required GetStudentCourses getStudentCourses})
    : _getStudentCourses = getStudentCourses,

      super(StudentCoursesInitial()) {
    on<LoadStudentCourses>((event, emit) async {
      if (!event.isSilent) {
        emit(StudentCoursesLoading());
      }
      final res = await _getStudentCourses(
        GetStudentCoursesParams(userId: event.userId),
      );
      res.fold(
        (l) => emit(StudentCoursesError(message: l.message)),
        (r) => emit(StudentCoursesLoaded(courses: r, isSilent: event.isSilent)),
      );
    });
  }
}
