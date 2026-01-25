part of 'auth_bloc.dart';

@immutable
sealed class AuthState {
  const AuthState();
}

final class AuthInitial extends AuthState {}

final class AuthLoding extends AuthState {}

final class AuthSuccess extends AuthState {
  final String uid;
  const AuthSuccess({required this.uid});
}

final class AuthAuthenticated extends AuthState {
  final Profile profile;
 const AuthAuthenticated({required this.profile});
}

final class AuthFailure extends AuthState {
  final String message;
  const AuthFailure(this.message);
}
