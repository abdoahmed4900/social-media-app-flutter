// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

import '../cache/cache_helper/cache_helper.dart';
import '../logic/app_bloc/app_bloc.dart';
import '../logic/firebase_helper/firebase_helper.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'constants.dart';

Future<bool?> showToast(
    {required String message,
    Toast toastLength = Toast.LENGTH_SHORT,
    required Color backgroundColor}) async {
  return await Fluttertoast.showToast(
      msg: message, toastLength: toastLength, backgroundColor: backgroundColor);
}

Future<String> pickImage(context) async {
  String source = '';
  await showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
            enableDrag: false,
            onClosing: () {},
            builder: (context) {
              return SizedBox(
                width: double.infinity,
                height: MediaQuery.sizeOf(context).height * 0.2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.camera_alt),
                                    Text('Camera')
                                  ],
                                ),
                              ),
                              onPressed: () {
                                source = 'Camera';
                                Navigator.pop(context);
                              }),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width / 20,
                          ),
                          ElevatedButton(
                              child: SizedBox(
                                height: MediaQuery.sizeOf(context).height * 0.1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.photo),
                                    Text('Gallery')
                                  ],
                                ),
                              ),
                              onPressed: () {
                                source = 'Gallery';
                                Navigator.pop(context);
                              }),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      });

  return source;
}

Future pickPostImages(String source, AppBloc bloc) async {
  if (source == 'Gallery') {
    List<XFile?>? pickedImages = await ImagePicker().pickMultiImage();

    for (var element in pickedImages) {
      bloc.pickedPostImages.add(element!.path);
    }
  } else {
    XFile? file = await ImagePicker().pickImage(source: ImageSource.camera);
    bloc.pickedPostImages.add(file!.path);
  }
  bloc.add(AddPostPhoto());
}

Future<XFile?> pickImageWithSource(String source) {
  return ImagePicker().pickImage(
      source: source == 'Camera' ? ImageSource.camera : ImageSource.gallery);
}

Future logOut(AppBloc bloc) async {
  await CacheHelper.removeValue('uId');
  uId = '';
  bloc.bottomNavIndex = 0;
  bloc.add(AppLogOut());
}

Future<bool?> successToast({required String message}) {
  return showToast(
      message: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.green);
}

void errorToast({required String error}) {
  showToast(
      message: error.toString(),
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.red);
}

void jumpToScreenEnd(BuildContext context, ScrollController controller) {
  Future.delayed(Duration(milliseconds: 100));
  controller.jumpTo(controller.position.maxScrollExtent +
      MediaQuery.sizeOf(context).height * 0.05);
}

Future<void> pickProfileImage(String source, AppBloc bloc) async {
  XFile? pickedImage = await pickImageWithSource(source);
  if (pickedImage != null) {
    File file = File(pickedImage.path);
    FirebaseHelper.uploadProfileImage(file, bloc);
  }
}

Future pickMessagePhoto(String source) async {
  List list = [];
  if (source == 'Gallery') {
    final images = await ImagePicker().pickMultiImage();
    for (var element in images) {
      list.add(element.path);
    }
  } else if (source == 'Camera') {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.camera);
    list.add(image!.path);
  }
  return list;
}

void removeUserFromFollowing(AppBloc bloc, String userId, UserModel otherUser) {
  bloc.userModel!.following = bloc.userModel!.following! - 1;
  bloc.userModel!.followingIds!.remove(userId);
  otherUser.followersIds!.remove(uId);
  otherUser.followers = otherUser.followers! - 1;
}

void addUserToFollowing(AppBloc bloc, String userId, UserModel otherUser) {
  bloc.userModel!.following = bloc.userModel!.following! + 1;
  bloc.userModel!.followingIds!.add(userId);
  otherUser.followersIds!.add(uId);
  otherUser.followers = otherUser.followers! + 1;
}

void addLike(PostModel model) {
  model.likesUsersId!.add(uId);
  model.likesUserNames!.add(model.userName);
  model.likes++;
}

void removeLike(PostModel model) {
  int index = model.likesUsersId!.indexOf(uId);
  model.likesUsersId!.remove(uId);
  model.likesUserNames!.removeAt(index);
  model.likes--;
}

void updatePostsUserName(
    QuerySnapshot<Map<String, dynamic>> data, String name, AppBloc bloc) {
  for (var element in data.docs) {
    PostModel model = PostModel.fromMap(element.data());
    if (model.userId == uId) {
      model.userName = name;
      bloc.add(EditProfile());
    }
    for (int i = 0; i < model.commentsNumber; i++) {
      if (model.commentsUsersIds![i] == uId) {
        model.commentsUsersNames![i] = name;
      }
    }
    bloc.postsCollection.doc(model.postId).update(model.toMap());
  }
}

void push(Widget widget, context) => Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => widget,
    ));
