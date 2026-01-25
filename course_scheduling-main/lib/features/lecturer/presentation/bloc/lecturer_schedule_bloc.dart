import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:course_scheduling/features/lecturer/domain/repositories/lecturer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'lecturer_schedule_event.dart';
part 'lecturer_schedule_state.dart';

class LecturerScheduleBloc extends Bloc<LecturerScheduleEvent, LecturerScheduleState> {
  final LecturerRepository _lecturerRepository;

  LecturerScheduleBloc({required LecturerRepository lecturerRepository})
      : _lecturerRepository = lecturerRepository,
        super(LecturerScheduleInitial()) {
    on<LoadLecturerSchedule>(_onLoadLecturerSchedule);
    on<AddScheduleItemEvent>(_onAddScheduleItem);
    on<DeleteScheduleItemEvent>(_onDeleteScheduleItem);
    on<UpdateScheduleItemEvent>(_onUpdateScheduleItem);
  }

  Future<void> _onLoadLecturerSchedule(
    LoadLecturerSchedule event,
    Emitter<LecturerScheduleState> emit,
  ) async {
    emit(LecturerScheduleLoading());
    // Fetch Schedule and Assignments in parallel
    final scheduleResult = await _lecturerRepository.getSchedule(lecturerId: event.lecturerId);
    final assignmentsResult = await _lecturerRepository.getLecturerAssignments(lecturerId: event.lecturerId);

    // Combine results
    List<ScheduleItem> schedule = [];
    List<Map<String, dynamic>> assignments = [];
    String? errorMessage;

    scheduleResult.fold(
      (failure) => errorMessage = failure.message,
      (data) => schedule = data,
    );

    assignmentsResult.fold(
      (failure) {
        // If getting assignments fails, we might still want to show schedule,
        // but adding new items might be broken.
        // For now, let's treat it as non-fatal or show error.
        errorMessage ??= failure.message;
      },
      (data) => assignments = data,
    );

    if (errorMessage != null) {
      emit(LecturerScheduleFailure(message: errorMessage!));
    } else {
      emit(LecturerScheduleLoaded(schedule: schedule, assignments: assignments));
    }
  }

  Future<void> _onAddScheduleItem(
    AddScheduleItemEvent event,
    Emitter<LecturerScheduleState> emit,
  ) async {
    final currentState = state;
    if (currentState is LecturerScheduleLoaded) {
      // Optimistic update or show loading?
      // Let's show loading to prevent double submit.
      // But preserving previous state is better for UX if we had a persistent UI.
      // We'll emit Loading.
      emit(LecturerScheduleLoading());

      final result = await _lecturerRepository.addScheduleItem(item: event.item);

      result.fold(
        (failure) => emit(LecturerScheduleFailure(message: failure.message)),
        (_) {
          // Reload
          add(LoadLecturerSchedule(lecturerId: event.item.lecturerId));
        },
      );
    }
  }

  Future<void> _onDeleteScheduleItem(
    DeleteScheduleItemEvent event,
    Emitter<LecturerScheduleState> emit,
  ) async {
     if (state is LecturerScheduleLoaded) {
       // We need lecturerId to reload.
       // We can get it from the event if we pass it, or store it.
       // Let's pass it in event for simplicity.
       emit(LecturerScheduleLoading());
       final result = await _lecturerRepository.deleteScheduleItem(id: event.id);

       result.fold(
         (failure) => emit(LecturerScheduleFailure(message: failure.message)),
         (_) => add(LoadLecturerSchedule(lecturerId: event.lecturerId)),
       );
     }
  }

  Future<void> _onUpdateScheduleItem(
    UpdateScheduleItemEvent event,
    Emitter<LecturerScheduleState> emit,
  ) async {
    if (state is LecturerScheduleLoaded) {
      emit(LecturerScheduleLoading());
      final result = await _lecturerRepository.updateScheduleItem(item: event.item);
      result.fold(
        (failure) => emit(LecturerScheduleFailure(message: failure.message)),
        (_) => add(LoadLecturerSchedule(lecturerId: event.item.lecturerId)),
      );
    }
  }
}
