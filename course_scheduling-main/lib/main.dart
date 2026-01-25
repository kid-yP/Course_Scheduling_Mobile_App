import 'package:course_scheduling/core/secrets/app_secrets.dart';
import 'package:course_scheduling/features/admin/data/datasources/admin_remote_data_source.dart';
import 'package:course_scheduling/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:course_scheduling/features/admin/presentation/bloc/admin_bloc.dart';
import 'package:course_scheduling/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:course_scheduling/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:course_scheduling/features/auth/domain/usecases/get_profile.dart';
import 'package:course_scheduling/features/auth/domain/usecases/user_sign_in.dart';
import 'package:course_scheduling/features/auth/domain/usecases/user_sign_up.dart';
import 'package:course_scheduling/features/auth/domain/usecases/user_sign_out.dart';
import 'package:course_scheduling/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:course_scheduling/features/auth/presentation/pages/login_page.dart';
import 'package:course_scheduling/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:course_scheduling/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:course_scheduling/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:course_scheduling/features/courses/data/datasources/courses_remote_data_source.dart';
import 'package:course_scheduling/features/courses/data/repositories/courses_repository_impl.dart';
import 'package:course_scheduling/features/courses/domain/usecases/get_student_courses.dart';
import 'package:course_scheduling/features/courses/presentation/bloc/student_courses_bloc.dart';
import 'package:course_scheduling/features/lecturer/data/datasources/lecturer_remote_data_source.dart';
import 'package:course_scheduling/features/lecturer/data/repository/lecturer_repository_impl.dart';
import 'package:course_scheduling/features/lecturer/presentation/bloc/lecturer_schedule_bloc.dart';
import 'package:course_scheduling/features/resources/data/datasources/resource_remote_data_source.dart';
import 'package:course_scheduling/features/resources/data/repositories/resource_repository_impl.dart';
import 'package:course_scheduling/features/resources/presentation/bloc/resource_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: AppSecrets.supabaseUrl,
    anonKey: AppSecrets.supabaseAnonKey,
  );

  final supabaseClient = Supabase.instance.client;

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => AuthBloc(
            userSignUp: UserSignUp(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(supabaseClient),
              ),
            ),
            userSignIn: UserSignIn(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(supabaseClient),
              ),
            ),
            getProfile: GetProfile(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(supabaseClient),
              ),
            ),
            userSignOut: UserSignOut(
              AuthRepositoryImpl(
                remoteDataSource: AuthRemoteDataSourceImpl(supabaseClient),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => StudentCoursesBloc(
            getStudentCourses: GetStudentCourses(
              CoursesRepositoryImpl(
                remoteDataSource:
                    CourseRemoteDataSourceImpl(supabaseClient),
              ),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ChatBloc(
            chatRepository: ChatRepositoryImpl(
              ChatRemoteDataSourceImpl(supabaseClient),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => ResourceBloc(
            resourceRepository: ResourceRepositoryImpl(
              ResourceRemoteDataSourceImpl(supabaseClient),
            ),
          ),
        ),
        BlocProvider(
          create: (_) => LecturerScheduleBloc(
            lecturerRepository: LecturerRepositoryImpl(
              LecturerRemoteDataSourceImpl(supabaseClient),
            ),
          ),
        ),
         BlocProvider(
          create: (_) => AdminBloc(adminRepository: AdminRepositoryImpl(AdminRemoteDataSourceImpl(supabaseClient)))
          ),
        
      ],
      child: MyApp(supabaseClient: supabaseClient),
    ),
  );
}

class MyApp extends StatelessWidget {
  final SupabaseClient supabaseClient;

  const MyApp({super.key, required this.supabaseClient});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: LoginPage(supabaseClient: supabaseClient),
    );
  }
}
