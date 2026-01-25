import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:course_scheduling/features/lecturer/domain/entities/schedule_item.dart';
import 'package:course_scheduling/features/lecturer/presentation/bloc/lecturer_schedule_bloc.dart';
import 'package:course_scheduling/features/lecturer/presentation/widgets/add_schedule_dialog.dart';
import 'package:course_scheduling/features/lecturer/presentation/widgets/edit_schedule_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LecturerDashboard extends StatefulWidget {
  final String userId;
  const LecturerDashboard({super.key, required this.userId});

  @override
  State<LecturerDashboard> createState() => _LecturerDashboardState();
}

class _LecturerDashboardState extends State<LecturerDashboard> {
  int _selectedDay = DateTime.now().weekday; // 1 = Monday, 7 = Sunday

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

  void _showEditDialog(BuildContext context, ScheduleItem item) {
    showDialog(
      context: context,
      builder: (context) => EditScheduleDialog(item: item),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<LecturerScheduleBloc, LecturerScheduleState>(
        builder: (context, state) {
          if (state is LecturerScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
           if (state is LecturerScheduleFailure) {
            return Center(child: Text(state.message));
          }
          if (state is LecturerScheduleLoaded) {
            final fullSchedule = state.schedule;
            // Filter by selected day
            final todaysClasses = fullSchedule
                .where((item) => item.dayOfWeek == _selectedDay)
                .toList();

            return Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      // Show all classes for the day, or "No classes"
                      if (todaysClasses.isEmpty) _buildNoClassesCard(),
                      ...todaysClasses.map((item) => _buildNextClassCard(item)),

                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                        child: Text(
                          "Week Overview",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      _buildWeekOverview(fullSchedule),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            );
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
      floatingActionButton: BlocBuilder<LecturerScheduleBloc, LecturerScheduleState>(
        builder: (context, state) {
          if (state is LecturerScheduleLoaded) {
            return FloatingActionButton(
              backgroundColor: const Color(0xFF00C853),
              onPressed: () => _showAddDialog(context, state.assignments),
              child: const Icon(Icons.add, color: Colors.white),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final dayName = _dayToString(_selectedDay);

    return Container(
      padding: const EdgeInsets.only(top: 50, left: 20, right: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade400, Colors.green.shade800],
          begin: Alignment.bottomRight,
          end: Alignment.topLeft,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            offset: Offset(0, 5),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "My Schedule",
                    style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Lecturer Dashboard",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
              Container(
                 padding: const EdgeInsets.all(8),
                 decoration: BoxDecoration(
                   color: Colors.white.withOpacity(0.2),
                   shape: BoxShape.circle,
                 ),
                 child: const Icon(Icons.calendar_today, color: Colors.white),
              )
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
             decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16),
                  onPressed: () {
                    setState(() {
                      _selectedDay = _selectedDay == 1 ? 7 : _selectedDay - 1;
                    });
                  },
                ),
                Text(
                  dayName,
                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                  onPressed: () {
                    setState(() {
                      _selectedDay = _selectedDay == 7 ? 1 : _selectedDay + 1;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
           const Text(
              "Tap below to verify schedule for other days",
              style: TextStyle(color: Colors.white60, fontSize: 12),
            ),
        ],
      ),
    );
  }

  Widget _buildNextClassCard(ScheduleItem item) {
    return GestureDetector(
      onTap: () => _showEditDialog(context, item),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF00C853),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
             BoxShadow(
              color: Colors.green.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.courseName ?? "Course",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(_duration(item.startTime, item.endTime), style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
               item.sectionName ?? "Section",
               style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  "${_formatTime(item.startTime)} - ${_formatTime(item.endTime)}",
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(width: 20),
                const Icon(Icons.location_on, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  item.location,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24),
            const SizedBox(height: 5),
            const Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.edit, color: Colors.white70, size: 16),
                SizedBox(width: 4),
                Text(
                  "Tap to reschedule",
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildNoClassesCard() {
     return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(child: Text("No classes scheduled for ${_dayToString(_selectedDay)}.")),
     );
  }

  Widget _buildWeekOverview(List<ScheduleItem> schedule) {
    // Count classes per day
    final counts = List.filled(7, 0);
    for (var item in schedule) {
      if (item.dayOfWeek >= 1 && item.dayOfWeek <= 7) {
        counts[item.dayOfWeek - 1]++;
      }
    }

    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SizedBox(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        itemCount: 7,
        itemBuilder: (context, index) {
          final count = counts[index];
          final dayIndex = index + 1;
          final isSelected = dayIndex == _selectedDay;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedDay = dayIndex;
              });
            },
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 5),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFE0F2F1) : Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
                border: isSelected ? Border.all(color: const Color(0xFF00C853), width: 2) : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    days[index],
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF00C853) : Colors.grey,
                       fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  const SizedBox(height: 8),
                   Container(
                     width: 30,
                     height: 30,
                     decoration: BoxDecoration(
                       color: isSelected ? const Color(0xFF00C853) : Colors.grey[300],
                       shape: BoxShape.circle,
                     ),
                     child: Center(
                       child: Text(
                         "$count",
                          style: TextStyle(color: isSelected ? Colors.white : Colors.grey[600]),
                       ),
                     ),
                   ),
                ],
              ),
            ),
          );
        },
      ),
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

  String _duration(TimeOfDay start, TimeOfDay end) {
    final d1 = DateTime(2022, 1, 1, start.hour, start.minute);
    final d2 = DateTime(2022, 1, 1, end.hour, end.minute);
    final diff = d2.difference(d1);
    return "${diff.inHours}h ${diff.inMinutes % 60}m";
  }
}
