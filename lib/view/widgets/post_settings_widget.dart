// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';

import '../../logic/app_bloc/app_bloc.dart';

class PostSettingsWidget extends StatelessWidget {
  const PostSettingsWidget({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: PopupMenuButton(
          child: Icon(Icons.more_vert),
          itemBuilder: (context) => [
                PopupMenuItem(
                    onTap: () {
                      AppBloc.get(context).removePost(postId: postModel.postId);
                    },
                    child: Row(
                      children: [
                        Text('Remove Post'),
                        Spacer(),
                        Icon(Icons.delete)
                      ],
                    ))
              ]),
    );
  }
}
