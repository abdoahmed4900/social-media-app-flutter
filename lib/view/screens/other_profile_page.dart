// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_null_comparison, use_build_context_synchronously

import 'package:chat_app/constants/styles/styles.dart';
import 'package:chat_app/logic/firebase_helper/firebase_helper.dart';
import 'package:chat_app/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../logic/app_bloc/app_bloc.dart';

class OtherProfileScreen extends StatelessWidget {
  UserModel userModel;

  OtherProfileScreen({super.key, required this.userModel});

  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: Padding(
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
                                radius:
                                    MediaQuery.sizeOf(context).width * 0.152,
                                child: Container(
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              userModel.userImage))),
                                )),
                          ],
                        )),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 47,
                  ),
                  Wrap(
                    children: [
                      Text(
                        userModel.name!,
                        style: profileFont(context),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 46.9,
                  ),
                  Wrap(
                    children: [
                      Text(userModel.bio!,
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.066,
                  ),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(userModel.uId)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          final data = snapshot.data;
                          userModel = UserModel.fromMap(data!.data()!);
                        }
                        return StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('users')
                                .doc(userModel.uId)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final data = snapshot.data;
                                userModel = UserModel.fromMap(data!.data()!);
                              }
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        userModel.followers.toString(),
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
                                        userModel.following.toString(),
                                        style: profileFont(context),
                                      ),
                                      Text('Following',
                                          style: profileFont(context))
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(userModel.yourPostsNumber.toString(),
                                          style: profileFont(context)),
                                      Text('Posts',
                                          style: profileFont(context)),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('36', style: profileFont(context)),
                                      Text('Photos',
                                          style: profileFont(context)),
                                    ],
                                  )
                                ],
                              );
                            });
                      }),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).height / 46.9,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.78,
                        child: ElevatedButton(
                            onPressed: () {
                              FirebaseHelper.followUser(userModel.uId, bloc);
                            },
                            child: Text(bloc.userModel!.followingIds!
                                    .contains(userModel.uId)
                                ? 'Following'
                                : 'Follow')),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
