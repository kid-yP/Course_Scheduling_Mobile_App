part of 'student_courses_bloc.dart';

@immutable
sealed class StudentCoursesState {}

final class StudentCoursesInitial extends StudentCoursesState {}

class StudentCoursesLoading extends StudentCoursesState {}

final class StudentCoursesLoaded extends StudentCoursesState {
  final Courses courses;
  final bool isSilent;
  StudentCoursesLoaded({required this.courses, this.isSilent = false});
}

class StudentCoursesError extends StudentCoursesState {
  final String message;

  StudentCoursesError({ required this.message});
}
