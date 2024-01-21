// ignore_for_file: prefer_const_constructors

import 'package:chat_app/cache/cache_helper/cache_helper.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/user.dart';

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterEvent>((event, emit) {
      if (event is RegisterButtonPressed) {
        emit(RegisterLoading());
        register(
            email: event.email,
            password: event.password,
            name: event.name,
            phone: event.phone);
      } else if (event is AppLoggedIn) {
        emit(RegisterSuccessful(event.credential));
      } else if (event is AppRegisterError) {
        emit(RegisterError(event.message));
      } else if (event is RegisterLoad) {
        emit(RegisterLoading());
      }
    });
  }

  static RegisterBloc get(context) => BlocProvider.of(context);
  void register(
      {required String email,
      required String password,
      required String name,
      required String phone,
      context}) async {
    add(RegisterLoad());
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      AppBloc.get(context).userModel = UserModel(
          email: email,
          name: name,
          bio: 'write about yourself',
          yourPostsNumber: 0,
          phone: phone,
          uId: value.user!.uid,
          followers: 0,
          followersIds: [],
          following: 0,
          followingIds: [],
          userImage: defaultImage,
          isEmailVerified: false);
      createUser(user: AppBloc.get(context).userModel!);

      await CacheHelper.setString('uId', AppBloc.get(context).userModel!.uId);

      uId = CacheHelper.getString('uId');

      CacheHelper.setBoolean('isEmailVerfiedBefore', false);

      AppBloc.get(context).isPassword = true;

      AppBloc.get(context).passwordIcon = Icons.visibility;

      add(AppLoggedIn(value));

      AppBloc.get(context).getUserData(context);
    }).catchError((error) {
      Navigator.pop(context);

      add(AppRegisterError(error.toString()));
    });
  }

  void createUser({required UserModel user}) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uId)
        .set(user.toMap());
    CacheHelper.setString('uId', user.uId);
  }
}
