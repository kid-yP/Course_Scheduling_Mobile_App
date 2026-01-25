import 'package:course_scheduling/core/error/failures.dart';
import 'package:course_scheduling/core/usecase/usecase.dart';
import 'package:course_scheduling/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

class UserSignUp implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;
  const UserSignUp(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params)async {
      return await authRepository.signUpWithEmailPasswrod(name: params.name, email: params.email, password: params.password);

  }


}
class UserSignUpParams{
  final String email;
  final String name;
  final String password;
  UserSignUpParams({required this.email, required this.name, required this.password});
}