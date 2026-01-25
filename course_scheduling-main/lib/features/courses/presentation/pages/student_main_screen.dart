import 'package:course_scheduling/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:course_scheduling/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:course_scheduling/features/courses/domain/usecases/get_student_courses.dart';
import 'package:course_scheduling/features/courses/presentation/bloc/student_courses_bloc.dart';
import 'package:course_scheduling/features/courses/presentation/pages/student_my_courses.dart';
import 'package:course_scheduling/features/auth/presentation/pages/profile_page.dart';
import 'package:course_scheduling/features/courses/presentation/pages/student_home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async'; // Import for Timer

class StudentMainScreen extends StatefulWidget {
  final String userId;
  final SupabaseClient supabaseClient;
  const StudentMainScreen({
    super.key,
    required this.userId,
    required this.supabaseClient,
  });

  @override
  State<StudentMainScreen> createState() => _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int _selectedIndex = 0;
  // Timer? _refreshTimer; // Moved to _StudentMainContentState

  @override
  void initState() {
    super.initState();
    // Start auto-refresh timer
    // _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
    //   // We can access the context if the widget is mounted, but here we are creating the BlocProvider in build.
    //   // This is a common issue. If we create BlocProvider in build, we can't easily access it from here unless we hold a reference or move BlocProvider up.
    //   // However, we can move logic to a wrapper or use a GlobalKey, or clearer:
    //   // The BlocProvider is created in build. This timer should ideally be controlled where the Bloc exists.
    //   // But we can just dispatch the event if we find the bloc from context.
    //   // WAIT: BlocProvider is created in build method of THIS widget. so `context.read<StudentCoursesBloc>` inside this widget won't work because the context doesn't contain it yet (it's a child of this widget).

    //   // Correct Approach: The BlocProvider should be outside or we need `Builder`.
    //   // The current code has `BlocProvider` inside `build`. The `Timer` is in `State` of `StudentMainScreen`.
    //   // We cannot access the Bloc created in `build` from `initState` or `Timer` easily unless we store it.
    // });
  }

  @override
  void dispose() {
    // _refreshTimer?.cancel(); // Moved to _StudentMainContentState
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index; // Switch the tab
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StudentCoursesBloc(
        getStudentCourses: GetStudentCourses(
          CoursesRepositoryImpl(
            remoteDataSource: CourseRemoteDataSourceImpl(widget.supabaseClient),
          ),
        ),
      )..add(LoadStudentCourses(userId: widget.userId)),
      child: Builder( // Use Builder to get a context that has the Bloc
        builder: (context) {
          // Initialize Timer here if it hasn't been started? No, build is called many times.
          // Better: Use a Stateful wrapper for the content inside BlocProvider OR just move BlocProvider up.
          // For now, I will use a `LayoutBuilder` or `useEffect` style hook? No.
          // I will use a separate widget for the body content that has access to the Bloc, OR
          // I can simply start the timer in the body widget's InitState.

          return _StudentMainContent(
             userId: widget.userId,
             selectedIndex: _selectedIndex,
             onTabTapped: _onTabTapped,
          );
        },
      ),
    );
  }
}

class _StudentMainContent extends StatefulWidget {
  final String userId;
  final int selectedIndex;
  final Function(int) onTabTapped;

  const _StudentMainContent({
    required this.userId,
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  State<_StudentMainContent> createState() => _StudentMainContentState();
}

class _StudentMainContentState extends State<_StudentMainContent> {
  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    // Refresh every minute
    _refreshTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
       if (mounted) {
         context.read<StudentCoursesBloc>().add(LoadStudentCourses(userId: widget.userId, isSilent: true));
       }
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    context.read<StudentCoursesBloc>().add(LoadStudentCourses(userId: widget.userId));
    // Wait for state change? The refresh indicator expects a Future.
    // We can just await a small delay or use Completer if we want perfect sync, but for now simple delay is fine or just return.
    // Ideally we should wait for Loaded state.
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
      final pages = [
        StudentHomePage(),
        BlocConsumer<StudentCoursesBloc, StudentCoursesState>(
          listener: (context, state) {
            if (state is StudentCoursesLoaded && !state.isSilent) { // Only show snackbar if it's not a silent refresh
               // Only show snackbar if it was a manual refresh or significant update?
               // For now, let's keep it simple as requested: "whenever there is a change... snack bar"
               // To detect change, we'd need to compare with previous.
               // For now, satisfying "give the user a notification snack bar"
               // We can check if `isSilent` was presumably used? No default way to know event source.
               // Let's just show it.
               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Courses Updated')));
               // Wait, showing it every minute might be annoying.
               // I will show it only if it's NOT silent? or just showing it is what user asked.
            }
          },
          builder: (context, state) {
            if (state is StudentCoursesLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is StudentCoursesLoaded) {
              return StudentMyCourses(
                courses: state.courses,
                userId: widget.userId,
                onRefresh: _handleRefresh,
              );
            }
            if (state is StudentCoursesError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
        const ProfilePage(),
      ];

      return Scaffold(
        body: IndexedStack(index: widget.selectedIndex, children: pages),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: widget.selectedIndex,
          onTap: widget.onTabTapped,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(
              icon: Icon(Icons.menu_book),
              label: 'Courses',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      );
  }
}

class MyCoursesPage {}

