// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:chat_app/models/post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/post_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);
        return ConditionalBuilder(
          condition: bloc.userModel != null,
          builder: (context) {
            return ConditionalBuilder(
              condition: bloc.userModel!.isEmailVerified,
              builder: (context) {
                if (state is AppLoading) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                return StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('posts')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) => PostWidget(
                                    key: GlobalKey(
                                        debugLabel: snapshot
                                            .data!
                                            .docs[snapshot.data!.docs.length -
                                                1 -
                                                index]
                                            .data()['postId']),
                                    postModel: PostModel.fromMap(snapshot
                                        .data!
                                        .docs[snapshot.data!.docs.length -
                                            1 -
                                            index]
                                        .data()),
                                    index:
                                        snapshot.data!.docs.length - 1 - index,
                                  ),
                              primary: false,
                              shrinkWrap: true,
                              separatorBuilder: (context, index) => Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.02,
                                      ),
                                      Divider(
                                        height:
                                            MediaQuery.sizeOf(context).height *
                                                0.004,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                              itemCount: snapshot.hasData
                                  ? snapshot.data!.docs.length
                                  : 0)
                        ],
                      ),
                    );
                  },
                );
              },
              fallback: (BuildContext context) => Center(
                child: ElevatedButton(
                    onPressed: () {
                      bloc.verifyEmail();
                    },
                    child: Text('Verify Email')),
              ),
            );
          },
          fallback: (context) {
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        );
      },
    );
  }
}
