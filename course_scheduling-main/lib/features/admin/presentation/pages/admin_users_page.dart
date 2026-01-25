import 'package:course_scheduling/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:course_scheduling/features/admin/presentation/pages/admin_user_detail_page.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminUsersPage extends StatefulWidget {
  const AdminUsersPage({super.key});

  @override
  State<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends State<AdminUsersPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<AdminBloc>().add(FetchStudents());
    context.read<AdminBloc>().add(FetchLecturers());
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Users', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(text: 'Students'),
            Tab(text: 'Lecturers'),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _UserList(role: 'student', searchQuery: _searchQuery),
                _UserList(role: 'lecturer', searchQuery: _searchQuery),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserList extends StatelessWidget {
  final String role;
  final String searchQuery;

  const _UserList({required this.role, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state.isLoading && (state.students == null && role == 'student' || state.lecturers == null && role == 'lecturer')) {
          return const Center(child: CircularProgressIndicator());
        }

        final users = role == 'student' ? state.students : state.lecturers;

        if (users == null) {
          return const Center(child: Text("No users found."));
        }

        final filteredUsers = users.where((user) {
          final name = user.name.toLowerCase();
          // final email = user.email.toLowerCase(); // Profile entity currently doesn't expose email public getter in some versions? Check entity.
          // Assuming name is what we have.
          return name.contains(searchQuery);
        }).toList();

        if (filteredUsers.isEmpty) {
          return const Center(child: Text("No matching users."));
        }

        return ListView.builder(
          itemCount: filteredUsers.length,
          itemBuilder: (context, index) {
            final user = filteredUsers[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: role == 'student' ? Colors.blue.shade100 : Colors.green.shade100,
                  foregroundColor: role == 'student' ? Colors.blue : Colors.green,
                  child: Text(user.name[0].toUpperCase()),
                ),
                title: Text(user.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(user.role.toUpperCase()),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AdminUserDetailPage(user: user),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
