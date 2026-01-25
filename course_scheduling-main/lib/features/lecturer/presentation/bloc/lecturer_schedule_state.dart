part of 'lecturer_schedule_bloc.dart';

@immutable
sealed class LecturerScheduleState {}

final class LecturerScheduleInitial extends LecturerScheduleState {}

final class LecturerScheduleLoading extends LecturerScheduleState {}

final class LecturerScheduleLoaded extends LecturerScheduleState {
  final List<ScheduleItem> schedule;
  final List<Map<String, dynamic>> assignments;

  LecturerScheduleLoaded({required this.schedule, required this.assignments});
}

final class LecturerScheduleFailure extends LecturerScheduleState {
  final String message;

  LecturerScheduleFailure({required this.message});
}
