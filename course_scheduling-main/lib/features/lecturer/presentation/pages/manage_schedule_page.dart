import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:course_scheduling/features/lecturer/presentation/bloc/lecturer_schedule_bloc.dart';
import 'package:course_scheduling/features/lecturer/presentation/widgets/add_schedule_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageSchedulePage extends StatefulWidget {
  final String userId;
  const ManageSchedulePage({super.key, required this.userId});

  @override
  State<ManageSchedulePage> createState() => _ManageSchedulePageState();
}

class _ManageSchedulePageState extends State<ManageSchedulePage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LecturerScheduleBloc>()
        .add(LoadLecturerSchedule(lecturerId: widget.userId));
  }

  void _showAddDialog(BuildContext context, List<Map<String, dynamic>> assignments) {
    showDialog(
      context: context,
      builder: (context) => AddScheduleDialog(
        assignments: assignments,
        lecturerId: widget.userId,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Schedule')),
      body: BlocConsumer<LecturerScheduleBloc, LecturerScheduleState>(
        listener: (context, state) {
          if (state is LecturerScheduleFailure) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is LecturerScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LecturerScheduleLoaded) {
            final schedule = state.schedule;

            if (schedule.isEmpty) {
               return const Center(child: Text('No classes scheduled.'));
            }

            return ListView.builder(
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final item = schedule[index];
                return Dismissible(
                  key: Key(item.id.toString()),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                     context.read<LecturerScheduleBloc>().add(
                          DeleteScheduleItemEvent(id: item.id, lecturerId: widget.userId),
                        );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppPallete.gradient2,
                        child: Text(
                          _dayToString(item.dayOfWeek).substring(0, 3),
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ),
                      title: Text(item.courseName ?? 'Course ${item.courseId}'),
                      subtitle: Text(
                        '${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}\n${item.location} • ${item.sectionName ?? "Section ${item.sectionId}"}',
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
      floatingActionButton: BlocBuilder<LecturerScheduleBloc, LecturerScheduleState>(
        builder: (context, state) {
          if (state is LecturerScheduleLoaded) {
            return FloatingActionButton(
              onPressed: () => _showAddDialog(context, state.assignments),
              child: const Icon(Icons.add),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  String _dayToString(int day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    if (day >= 1 && day <= 7) return days[day - 1];
    return '';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
