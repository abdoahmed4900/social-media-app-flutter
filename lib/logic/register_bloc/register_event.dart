part of 'register_bloc.dart';

@immutable
abstract class RegisterEvent {}

class RegisterButtonPressed extends RegisterEvent {
  final String email;
  final String password;
  final String name;
  final String phone;

  RegisterButtonPressed(this.phone,
      {required this.email, required this.password, required this.name});
}

class AppLoggedIn extends RegisterEvent {
  final UserCredential credential;
  AppLoggedIn(this.credential);
}

class AppRegisterError extends RegisterEvent {
  final String message;
  AppRegisterError(this.message);
}

class RegisterLoad extends RegisterEvent {
  RegisterLoad();
}
