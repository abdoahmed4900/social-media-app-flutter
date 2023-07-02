// ignore_for_file: prefer_const_constructors

part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginError extends LoginState {
  final String message;
  LoginError(this.message);
}

class LoginLoading extends LoginState {}

class AppLoginLoading extends LoginState {
  AppLoginLoading();
}

class LoginSuccessful extends LoginState {
  LoginSuccessful();
}
