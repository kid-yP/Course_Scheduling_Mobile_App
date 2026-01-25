import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:course_scheduling/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUserDetailPage extends StatefulWidget {
  final Profile user;
  const AdminUserDetailPage({super.key, required this.user});

  @override
  State<AdminUserDetailPage> createState() => _AdminUserDetailPageState();
}

class _AdminUserDetailPageState extends State<AdminUserDetailPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBloc>().add(FetchEnrollments(userId: widget.user.userId, role: widget.user.role));
  }

  void _showAssignDialog() {
    showDialog(
      context: context,
      builder: (context) => _AssignDialog(user: widget.user),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.user.name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.purple, Colors.deepPurple],
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
            ),
             borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAssignDialog,
        label: const Text("Assign"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      body: BlocConsumer<AdminBloc, AdminState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
            context.read<AdminBloc>().add(ClearAdminMessages());
          }
          if (state.successMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.successMessage!), backgroundColor: Colors.green));
            context.read<AdminBloc>().add(ClearAdminMessages());
          }
        },
        builder: (context, state) {
           if (state.isLoading && state.currentEnrollments == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final enrollments = state.currentEnrollments;

          if (enrollments == null || enrollments.isEmpty) {
            return const Center(child: Text("No enrollments found."));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: enrollments.length,
            itemBuilder: (context, index) {
              final enrollment = enrollments[index];
              final section = enrollment['sections']; // This might vary based on query structure?
              // Query was: sections (courses (name, code), section_name)
              final course = section['courses'];
              final sectionName = section['section_name'] ?? 'Section';

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  leading: const Icon(Icons.book, color: Colors.purple),
                  title: Text(course['name']),
                  subtitle: Text("${course['code']} - $sectionName"),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _AssignDialog extends StatefulWidget {
  final Profile user;
  const _AssignDialog({required this.user});

  @override
  State<_AssignDialog> createState() => _AssignDialogState();
}

class _AssignDialogState extends State<_AssignDialog> {
  int? selectedCourseId;
  int? selectedSectionId;

  @override
  void initState() {
    super.initState();
    // Fetch courses when dialog opens
    // Note: We need the AdminBloc. Since dialog is in same context hierarchy? Yes, simplified.
    // Use read to add event.
    context.read<AdminBloc>().add(FetchAllCourses());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        return AlertDialog(
          title: Text("Assign to ${widget.user.role == 'student' ? 'Course Section' : 'Course'}"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (state.courses != null)
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Select Course'),
                  items: state.courses!.map((course) {
                    return DropdownMenuItem<int>(
                      value: course['id'],
                      child: Text("${course['code']} - ${course['name']}", overflow: TextOverflow.ellipsis),
                    );
                  }).toList(),
                  onChanged: (value) {
                     setState(() {
                       selectedCourseId = value;
                       selectedSectionId = null;
                     });
                     if (value != null) {
                       context.read<AdminBloc>().add(FetchCourseSections(courseId: value));
                     }
                  },
                ),
              const SizedBox(height: 16),
              if (selectedCourseId != null && state.sections != null)
                 DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Select Section'),
                  items: state.sections!.map((section) {
                    return DropdownMenuItem<int>(
                      value: section['id'],
                      child: Text(section['section_name'] ?? 'Section ${section['id']}'),
                    );
                  }).toList(),
                  onChanged: (value) {
                     setState(() {
                       selectedSectionId = value;
                     });
                  },
                ),
               if (state.isLoading)
                  const Padding(padding: EdgeInsets.only(top: 10), child: LinearProgressIndicator()),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: (selectedSectionId != null) ? () {
                 if (widget.user.role == 'student') {
                   context.read<AdminBloc>().add(AssignStudent(studentId: widget.user.userId, sectionId: selectedSectionId!));
                 } else {
                   context.read<AdminBloc>().add(AssignLecturer(lecturerId: widget.user.userId, sectionId: selectedSectionId!));
                 }
                 Navigator.pop(context);
              } : null,
              child: const Text("Assign"),
            ),
          ],
        );
      },
    );
  }
}
