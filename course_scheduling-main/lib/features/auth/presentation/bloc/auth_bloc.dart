import 'package:course_scheduling/core/usecase/usecase.dart';
import 'package:course_scheduling/features/auth/domain/entities/profile.dart';
import 'package:course_scheduling/features/auth/domain/usecases/get_profile.dart';
import 'package:course_scheduling/features/auth/domain/usecases/user_sign_in.dart';
import 'package:course_scheduling/features/auth/domain/usecases/user_sign_up.dart';
import 'package:course_scheduling/features/auth/domain/usecases/user_sign_out.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final GetProfile _getProfile;
  final UserSignOut _userSignOut;

  AuthBloc({
    required UserSignUp userSignUp,
    required UserSignIn userSignIn,
    required GetProfile getProfile,
    required UserSignOut userSignOut,
  })  : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _getProfile = getProfile,
        _userSignOut = userSignOut,
        super(AuthInitial()) {

    on<AuthSignUp>((event, emit) async {
      final res = await _userSignUp(
        UserSignUpParams(
          email: event.email,
          name: event.name,
          password: event.password,
        ),
      );

      res.fold(
        (l) => emit(AuthFailure(l.message)),
        (r) => emit(AuthSuccess(uid: r)),
      );
    });

    on<AuthSignIn>((event, emit) async {
      final res = await _userSignIn(
        UserSignInParams(email: event.email, password: event.password),
      );

       if (res.isLeft()) {
    emit(AuthFailure(res.getLeft().toNullable()!.message));
  } else {
    final uid = res.getRight().toNullable()!;
    debugPrint("user signed in successfully! UID: $uid");

    final profileResult = await _getProfile(GetProfileParams(userId: uid));

    if (profileResult.isLeft()) {
      emit(AuthFailure(profileResult.getLeft().toNullable()!.message));
    } else {
      final profile = profileResult.getRight().toNullable()!;
      emit(AuthAuthenticated(profile: profile));
    }
  }
    });

    on<AuthSignOut>((event, emit) async {
      final res = await _userSignOut(NoParams());
      res.fold(
        (l) => emit(AuthFailure(l.message)), // Or handle silently?
        (r) => emit(AuthInitial()), // Reset to initial state implies logout
      );
    });
  }
}
