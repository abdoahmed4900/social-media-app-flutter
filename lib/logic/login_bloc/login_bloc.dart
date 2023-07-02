// ignore_for_file: prefer_const_constructors

import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cache/cache_helper/cache_helper.dart';
import '../../constants/constants.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) {
      if (event is LoginButtonPressed) {
        emit(LoginLoading());
        login(email: event.email, password: event.password);
      } else if (event is AppLoggedIn) {
        emit(LoginSuccessful());
      } else if (event is AppLoginError) {
        emit(LoginError(event.message));
      } else if (event is LoadApp) {
        emit(LoginLoading());
      }
    });
  }

  static LoginBloc get(context) => BlocProvider.of(context);

  void login({required String email, required String password, context}) async {
    add(LoadApp());
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      await CacheHelper.setString('uId', value.user!.uid);
      uId = CacheHelper.getString('uId');

      AppBloc.get(context).isPassword = true;

      AppBloc.get(context).passwordIcon = Icons.visibility;

      AppBloc.get(context).getUserData(context);

      add(AppLoggedIn());
    }).catchError((error) {
      Navigator.pop(context);
      add(AppLoginError(error.toString()));
    });
  }
}
