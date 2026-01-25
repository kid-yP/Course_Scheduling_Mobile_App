import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUpWithEmailPasswrod({
    required String name,
    required String email,
    required String password,
  });
  Future<Either<Failure, String>> loginWithEmailPassword({
    required String email,
    required String password,
  });
  Future<Either<Failure, Profile>> getProfile({
    required String userId,
  });
  Future<Either<Failure, void>> signOut();
}
