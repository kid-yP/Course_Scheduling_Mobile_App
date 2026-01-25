import 'package:course_scheduling/core/theme/app_pallet.dart';
import 'package:course_scheduling/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:course_scheduling/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:course_scheduling/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:course_scheduling/features/admin/presentation/pages/admin_users_page.dart';
import 'package:course_scheduling/features/auth/presentation/pages/profile_page.dart';
import 'package:course_scheduling/features/admin/presentation/pages/admin_dashboard.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int _selectedIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminBloc(
        adminRepository: AdminRepositoryImpl(
          AdminRemoteDataSourceImpl(Supabase.instance.client),
        ),
      )..add(FetchAllCourses()),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            AdminDashboard(),
            AdminUsersPage(),
            ProfilePage(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onTabTapped,
          selectedItemColor: Colors.purple,
          unselectedItemColor: Colors.grey,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
