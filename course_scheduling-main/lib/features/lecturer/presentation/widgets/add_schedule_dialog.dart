import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:course_scheduling/features/lecturer/presentation/bloc/lecturer_schedule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddScheduleDialog extends StatefulWidget {
  final List<Map<String, dynamic>> assignments;
  final String lecturerId;

  const AddScheduleDialog({
    super.key,
    required this.assignments,
    required this.lecturerId,
  });

  @override
  State<AddScheduleDialog> createState() => _AddScheduleDialogState();
}

class _AddScheduleDialogState extends State<AddScheduleDialog> {
  final _formKey = GlobalKey<FormState>();

  Map<String, dynamic>? _selectedAssignment;
  int _selectedDay = 1;
  TimeOfDay _startTime = const TimeOfDay(hour: 9, minute: 0);
  TimeOfDay _endTime = const TimeOfDay(hour: 10, minute: 0);
  final _locationController = TextEditingController();

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Unique list of assignments for dropdown
    final assignments = widget.assignments;

    return AlertDialog(
      title: const Text('Add Class'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Map<String, dynamic>>(
                decoration: const InputDecoration(labelText: 'Course & Section'),
                items: assignments.map((assignment) {
                  final courseName = assignment['courses']['name'];
                  final sectionName = assignment['sections']['name'];
                  return DropdownMenuItem(
                    value: assignment,
                    child: Text('$courseName - $sectionName'),
                  );
                }).toList(),
                onChanged: (val) {
                  setState(() {
                    _selectedAssignment = val;
                  });
                },
                validator: (val) => val == null ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: _selectedDay,
                decoration: const InputDecoration(labelText: 'Day'),
                items: List.generate(7, (index) {
                  return DropdownMenuItem(
                    value: index + 1,
                    child: Text(_dayToString(index + 1)),
                  );
                }),
                onChanged: (val) => setState(() => _selectedDay = val!),
              ),
              const SizedBox(height: 10),
              ListTile(
                title: const Text('Start Time'),
                trailing: Text(_formatTime(_startTime)),
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: _startTime);
                  if (t != null) setState(() => _startTime = t);
                },
              ),
              ListTile(
                title: const Text('End Time'),
                trailing: Text(_formatTime(_endTime)),
                onTap: () async {
                  final t = await showTimePicker(context: context, initialTime: _endTime);
                  if (t != null) setState(() => _endTime = t);
                },
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newItem = ScheduleItem(
                id: 0, // Ignored by add
                courseId: _selectedAssignment!['course_id'],
                sectionId: _selectedAssignment!['section_id'],
                lecturerId: widget.lecturerId,
                dayOfWeek: _selectedDay,
                startTime: _startTime,
                endTime: _endTime,
                location: _locationController.text,
              );
              context.read<LecturerScheduleBloc>().add(AddScheduleItemEvent(item: newItem));
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        ),
      ],
    );
  }

  String _dayToString(int day) {
    const days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
    if (day >= 1 && day <= 7) return days[day - 1];
    return '';
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
