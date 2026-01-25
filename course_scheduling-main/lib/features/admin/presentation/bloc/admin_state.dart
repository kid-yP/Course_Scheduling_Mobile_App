part of 'admin_bloc.dart';

@immutable
class AdminState {
  final bool isLoading;
  final String? errorMessage;
  final String? successMessage;
  final List<Profile>? students;
  final List<Profile>? lecturers;
  final List<Map<String, dynamic>>? courses;
  final List<Map<String, dynamic>>? sections;
  final List<Map<String, dynamic>>? currentEnrollments;

  const AdminState({
    this.isLoading = false,
    this.errorMessage,
    this.successMessage,
    this.students,
    this.lecturers,
    this.courses,
    this.sections,
    this.currentEnrollments,
  });

  factory AdminState.initial() => const AdminState();

  AdminState copyWith({
    bool? isLoading,
    String? errorMessage,
    String? successMessage,
    List<Profile>? students,
    List<Profile>? lecturers,
    List<Map<String, dynamic>>? courses,
    List<Map<String, dynamic>>? sections,
    List<Map<String, dynamic>>? currentEnrollments,
  }) {
    return AdminState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Reset error on new state unless explicitly passed? Or keep? usually reset involved in flow.
      successMessage: successMessage,
      students: students ?? this.students,
      lecturers: lecturers ?? this.lecturers,
      courses: courses ?? this.courses,
      sections: sections ?? this.sections,
      currentEnrollments: currentEnrollments ?? this.currentEnrollments,
    );
  }
}
