// ignore_for_file: prefer_const_constructors

part of 'register_bloc.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterError extends RegisterState {
  final String message;
  RegisterError(this.message);
}

class RegisterLoading extends RegisterState {}

class RegisterSuccessful extends RegisterState {
  final UserCredential credential;
  RegisterSuccessful(this.credential);
}

class AppRegisterLoading extends RegisterState {
  AppRegisterLoading();
}
