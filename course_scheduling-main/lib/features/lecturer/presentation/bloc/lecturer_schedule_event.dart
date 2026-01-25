part of 'lecturer_schedule_bloc.dart';

@immutable
sealed class LecturerScheduleEvent {}

class LoadLecturerSchedule extends LecturerScheduleEvent {
  final String lecturerId;
  LoadLecturerSchedule({required this.lecturerId});
}

class AddScheduleItemEvent extends LecturerScheduleEvent {
  final ScheduleItem item;
  AddScheduleItemEvent({required this.item});
}

class DeleteScheduleItemEvent extends LecturerScheduleEvent {
  final int id;
  final String lecturerId;
  DeleteScheduleItemEvent({required this.id, required this.lecturerId});
}

class UpdateScheduleItemEvent extends LecturerScheduleEvent {
  final ScheduleItem item;
  UpdateScheduleItemEvent({required this.item});
}
