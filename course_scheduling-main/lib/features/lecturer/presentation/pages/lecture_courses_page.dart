import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:course_scheduling/features/lecturer/presentation/bloc/lecturer_schedule_bloc.dart';
import 'package:course_scheduling/features/lecturer/presentation/pages/lecture_section_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LectureCoursesPage extends StatefulWidget {
  final String userId;
  const LectureCoursesPage({super.key, required this.userId});

  @override
  State<LectureCoursesPage> createState() => _LectureCoursesPageState();
}

class _LectureCoursesPageState extends State<LectureCoursesPage> {
  @override
  void initState() {
    super.initState();
    context
        .read<LecturerScheduleBloc>()
        .add(LoadLecturerSchedule(lecturerId: widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF66BB6A), Color(0xFF2E7D32)], // Green Gradient
              begin: Alignment.bottomRight,
              end: Alignment.topLeft,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
               BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 3),
                blurRadius: 8,
              ),
            ],
          ),
        ),
        title: BlocBuilder<LecturerScheduleBloc, LecturerScheduleState>(
          builder: (context, state) {
            int count = 0;
            if (state is LecturerScheduleLoaded) {
              count = state.assignments.length;
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Teaching",
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "$count courses this semester",
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            );
          },
        ),
      ),
      backgroundColor: Colors.grey[50],
      body: BlocBuilder<LecturerScheduleBloc, LecturerScheduleState>(
        builder: (context, state) {
          if (state is LecturerScheduleLoading) {
            return const Center(child: CircularProgressIndicator());
          }
           if (state is LecturerScheduleFailure) {
            return Center(child: Text(state.message));
          }
          if (state is LecturerScheduleLoaded) {
            final assignments = state.assignments;
            if (assignments.isEmpty) {
              return const Center(child: Text('No courses assigned.'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final courseName = assignment['courses']['name'];
                final courseCode = assignment['courses']['code'] ?? "CS${100+index}";
                final sectionName = assignment['sections']['name'];

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                       BoxShadow(
                        color: Colors.grey.withOpacity(0.15),
                        blurRadius: 15,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(20),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LectureSectionPage(
                                courseId: assignment['course_id'],
                                sectionId: assignment['section_id'],
                                courseName: courseName,
                                sectionName: sectionName,
                                userId: widget.userId,
                              ),
                            ),
                          );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                 Container(
                                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                   decoration: BoxDecoration(
                                     color: Colors.green.withOpacity(0.1),
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                   child: Text(courseCode, style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
                                 ),
                                 const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey)
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(courseName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF2E7D32))), // Dark Green
                            const SizedBox(height: 4),
                            Text(sectionName, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.access_time_filled, size: 18, color: Colors.green),
                                const SizedBox(width: 6),
                                const Text("Mon & Wed, 09:00-11:00", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 8),
                             Row(
                              children: [
                                const Icon(Icons.location_on, size: 18, color: Colors.green),
                                const SizedBox(width: 6),
                                const Text("Room 101", style: TextStyle(color: Colors.black87, fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                 const Text("Course Progress", style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                                 const Spacer(),
                                  const Text("75%", style: TextStyle(fontSize: 14, color: Colors.green, fontWeight: FontWeight.bold)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: LinearProgressIndicator(
                                value: 0.75,
                                backgroundColor: Colors.green.withOpacity(0.1),
                                valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF00C853)), // Green accent
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text('Initializing...'));
        },
      ),
    );
  }
}
