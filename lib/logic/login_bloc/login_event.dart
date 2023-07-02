part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginButtonPressed extends LoginEvent {
  final String email;
  final String password;
  LoginButtonPressed({required this.email, required this.password});
}

class AppLoggedIn extends LoginEvent {
  AppLoggedIn();
}

class AppLoginError extends LoginEvent {
  final String message;
  AppLoginError(this.message);
}

class LoadApp extends LoginEvent {}
