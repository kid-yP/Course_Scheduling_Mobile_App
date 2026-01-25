import 'package:course_scheduling/features/admin/domain/repositories/admin_repository.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart'; // Import Profile
import 'package:flutter/foundation.dart'; // for @immutable
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final AdminRepository _adminRepository;

  AdminBloc({required AdminRepository adminRepository})
    : _adminRepository = adminRepository,
      super(AdminState.initial()) {

    on<FetchStudents>(_onFetchStudents);
    on<FetchLecturers>(_onFetchLecturers);
    on<FetchEnrollments>(_onFetchEnrollments);
    on<FetchAllCourses>(_onFetchAllCourses);
    on<FetchCourseSections>(_onFetchCourseSections);
    on<AssignStudent>(_onAssignStudent);
    on<AssignLecturer>(_onAssignLecturer);
    on<ClearAdminMessages>((event, emit) => emit(state.copyWith(errorMessage: null, successMessage: null)));
  }

  Future<void> _onFetchStudents(FetchStudents event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _adminRepository.getUsersByRole('student');
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, errorMessage: l.message)),
      (r) => emit(state.copyWith(isLoading: false, students: r)),
    );
  }

  Future<void> _onFetchLecturers(FetchLecturers event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _adminRepository.getUsersByRole('lecturer');
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, errorMessage: l.message)),
      (r) => emit(state.copyWith(isLoading: false, lecturers: r)),
    );
  }

  Future<void> _onFetchEnrollments(FetchEnrollments event, Emitter<AdminState> emit) async {
    // Don't set full loading to true if we want to keep the list visible?
    // Usually detail view has its own loader. We can use isLoading for global or just rely on separate fields?
    // Let's use global isLoading for now.
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _adminRepository.getUserEnrollments(event.userId, event.role);
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, errorMessage: l.message)),
      (r) => emit(state.copyWith(isLoading: false, currentEnrollments: r)),
    );
  }

  Future<void> _onFetchAllCourses(FetchAllCourses event, Emitter<AdminState> emit) async {
    // Might not need full screen loading
    final result = await _adminRepository.getAllCourses();
    result.fold(
       (l) => emit(state.copyWith(errorMessage: l.message)),
       (r) => emit(state.copyWith(courses: r)),
    );
  }

  Future<void> _onFetchCourseSections(FetchCourseSections event, Emitter<AdminState> emit) async {
    final result = await _adminRepository.getCourseSections(event.courseId);
    result.fold(
      (l) => emit(state.copyWith(errorMessage: l.message)),
      (r) => emit(state.copyWith(sections: r)),
    );
  }

  Future<void> _onAssignStudent(AssignStudent event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _adminRepository.assignStudentToSection(
      studentId: event.studentId,
      sectionId: event.sectionId
    );
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, errorMessage: l.message)),
      (r) {
        // Success. Now refresh enrollments and maybe student list if needed?
        emit(state.copyWith(isLoading: false, successMessage: "Student assigned successfully"));
        add(FetchEnrollments(userId: event.studentId, role: 'student'));
      },
    );
  }

  Future<void> _onAssignLecturer(AssignLecturer event, Emitter<AdminState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    final result = await _adminRepository.assignLecturerToSection(
      lecturerId: event.lecturerId,
      sectionId: event.sectionId
    );
    result.fold(
      (l) => emit(state.copyWith(isLoading: false, errorMessage: l.message)),
      (r) {
        emit(state.copyWith(isLoading: false, successMessage: "Lecturer assigned successfully"));
        add(FetchEnrollments(userId: event.lecturerId, role: 'lecturer'));
      },
    );
  }
}
