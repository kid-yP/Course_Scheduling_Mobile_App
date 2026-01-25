import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:course_scheduling/features/chat/presentation/pages/chat_page.dart';
import 'package:course_scheduling/features/resources/presentation/pages/resource_page.dart';
import 'package:flutter/material.dart';

class LectureSectionPage extends StatefulWidget {
  final int courseId;
  final int sectionId;
  final String courseName;
  final String sectionName;
  final String userId;

  const LectureSectionPage({
    super.key,
    required this.courseId,
    required this.sectionId,
    required this.courseName,
    required this.sectionName,
    required this.userId,
  });

  @override
  State<LectureSectionPage> createState() => _LectureSectionPageState();
}

class _LectureSectionPageState extends State<LectureSectionPage> {
  int _currIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      ChatPage(
        courseId: widget.courseId,
        sectionId: widget.sectionId,
        userId: widget.userId,
        isLecturer: true,
      ),
      ResourcePage(
        courseId: widget.courseId,
        sectionId: widget.sectionId,
        userId: widget.userId,
        userRole: 'lecturer',
      ),
    ];

    return Scaffold(
      // AppBar is handled by children? No. Children are pages.
      // ChatPage has AppBar. ResourcePage has AppBar.
      // So we should not use a common AppBar, but let children handle it?
      // Or wrap them in IndexedStack.
      // But ChatPage expects to be a full page.
      // We can use a BottomNavBar to switch.
      body: pages[_currIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currIndex,
        onTap: (index) => setState(() => _currIndex = index),
        selectedItemColor: const Color(0xFF00C853),
        items: const [
          BottomNavigationBarItem(
             icon: Icon(Icons.chat),
             label: 'Chat',
          ),
          BottomNavigationBarItem(
             icon: Icon(Icons.folder),
             label: 'Resources',
          ),
        ],
      ),
    );
  }
}
