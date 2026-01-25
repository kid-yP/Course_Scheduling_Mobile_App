import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:course_scheduling/features/lecturer/presentation/bloc/lecturer_schedule_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditScheduleDialog extends StatefulWidget {
  final ScheduleItem item;

  const EditScheduleDialog({
    super.key,
    required this.item,
  });

  @override
  State<EditScheduleDialog> createState() => _EditScheduleDialogState();
}

class _EditScheduleDialogState extends State<EditScheduleDialog> {
  final _formKey = GlobalKey<FormState>();

  late int _selectedDay;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;
  late TextEditingController _locationController;

  @override
  void initState() {
    super.initState();
    _selectedDay = widget.item.dayOfWeek;
    _startTime = widget.item.startTime;
    _endTime = widget.item.endTime;
    _locationController = TextEditingController(text: widget.item.location);
  }

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Reschedule Class'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Read-only info
              Text(
                "${widget.item.courseName ?? 'Unknown Course'} - ${widget.item.sectionName ?? ''}",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 16),
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
              final updatedItem = ScheduleItem(
                id: widget.item.id,
                courseId: widget.item.courseId,
                sectionId: widget.item.sectionId,
                lecturerId: widget.item.lecturerId,
                dayOfWeek: _selectedDay,
                startTime: _startTime,
                endTime: _endTime,
                location: _locationController.text,
                courseName: widget.item.courseName,
                sectionName: widget.item.sectionName,
              );
              context.read<LecturerScheduleBloc>().add(UpdateScheduleItemEvent(item: updatedItem));
              Navigator.pop(context);
            }
          },
          child: const Text('Save'),
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
