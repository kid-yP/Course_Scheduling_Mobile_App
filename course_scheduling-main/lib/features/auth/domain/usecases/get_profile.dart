import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/core/usecase/usecase.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';
import 'package:course_scheduling/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GetProfile implements UseCase<Profile, GetProfileParams> {

  final AuthRepository authRepository;
  const GetProfile(this.authRepository);
  @override
  Future<Either<Failure, Profile>> call(GetProfileParams params)async {
      return await authRepository.getProfile(userId: params.userId);

  }


}
class GetProfileParams{
  final String userId;
  GetProfileParams({required this.userId});
}

