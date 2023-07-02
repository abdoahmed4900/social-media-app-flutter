// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_null_comparison, use_build_context_synchronously

import 'package:chat_app/constants/styles/icon_broken.dart';
import 'package:chat_app/constants/styles/styles.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/view/screens/edit_profile_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/methods.dart';
import '../../../logic/app_bloc/app_bloc.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key, this.isYourProfile = true});

  final bool isYourProfile;

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);
        return Padding(
          padding: EdgeInsets.all(MediaQuery.sizeOf(context).width * 0.02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.02,
                ),
                Center(
                  child: SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.142,
                      child: Stack(
                        children: [
                          CircleAvatar(
                              radius: MediaQuery.sizeOf(context).width * 0.152,
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                            bloc.userModel!.userImage))),
                              )),
                          Positioned(
                            right: MediaQuery.sizeOf(context).width * 0.014,
                            bottom: 0,
                            child: CircleAvatar(
                              radius: MediaQuery.sizeOf(context).width * 0.0415,
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              child: IconButton(
                                  iconSize:
                                      MediaQuery.sizeOf(context).width * 0.04,
                                  onPressed: () async {
                                    final source = await pickImage(context);
                                    pickProfileImage(
                                        source, AppBloc.get(context));
                                  },
                                  icon: Icon(
                                    IconBroken.Camera,
                                  )),
                            ),
                          ),
                        ],
                      )),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 46.9,
                ),
                Wrap(
                  children: [
                    Text(
                      bloc.userModel!.name!,
                      style: profileFont(context),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 46.9,
                ),
                Wrap(
                  children: [
                    Text(bloc.userModel!.bio!,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height * 0.066,
                ),
                StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(bloc.userModel!.uId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final data = snapshot.data;
                        bloc.userModel = UserModel.fromMap(data!.data()!);
                      }
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                bloc.userModel!.followers.toString(),
                                style: profileFont(context),
                              ),
                              Text(
                                'Followers',
                                style: profileFont(context),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                bloc.userModel!.following.toString(),
                                style: profileFont(context),
                              ),
                              Text('Following', style: profileFont(context))
                            ],
                          ),
                          Column(
                            children: [
                              Text(bloc.userModel!.yourPostsNumber.toString(),
                                  style: profileFont(context)),
                              Text('Posts', style: profileFont(context)),
                            ],
                          ),
                          Column(
                            children: [
                              Text('36', style: profileFont(context)),
                              Text('Photos', style: profileFont(context)),
                            ],
                          )
                        ],
                      );
                    }),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 46.9,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.78,
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.05)),
                      child: TextButton(
                          onPressed: () {}, child: Text('Add Photo')),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width * 0.14,
                      decoration:
                          BoxDecoration(border: Border.all(width: 0.05)),
                      child: TextButton(
                          onPressed: () {
                            push(
                                EditProfileScreen(
                                  bio: bloc.userModel!.bio!,
                                  name: bloc.userModel!.name!,
                                  phone: bloc.userModel!.phone!,
                                ),
                                context);
                          },
                          child: Icon(IconBroken.Edit_Square)),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
