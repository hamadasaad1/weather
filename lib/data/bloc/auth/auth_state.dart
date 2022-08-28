part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoginLoadingState extends AuthState {}

class AuthLoginSuccessState extends AuthState {}

class AuthLoginErrorState extends AuthState {
  final String message;

  AuthLoginErrorState(this.message);
}

class AuthSignUpLoadingState extends AuthState {}

class AuthSignUpSuccessState extends AuthState {}

class AuthSignUpErrorState extends AuthState {
  final String message;

  AuthSignUpErrorState(this.message);
}

class AuthUpdateProfileLoadingState extends AuthState {}

class AuthUpdateProfileSuccessState extends AuthState {}

class AuthUpdateProfileErrorState extends AuthState {
  final String message;

  AuthUpdateProfileErrorState(this.message);
}

class AuthUpdatePasswordLoadingState extends AuthState {}

class AuthUpdatePasswordSuccessState extends AuthState {}

class AuthUpdatePasswordErrorState extends AuthState {
  final String message;

  AuthUpdatePasswordErrorState(this.message);
}

class AuthUpdateUserLoadingState extends AuthState {}

class AuthUpdateUserDataState extends AuthState {
  final UserModel userModel;

  AuthUpdateUserDataState(this.userModel);
}

class AuthUpdateUserSuccessState extends AuthState {}

class AuthUpdateUserErrorState extends AuthState {
  final String message;

  AuthUpdateUserErrorState(this.message);
}
