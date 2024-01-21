import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../constants/styles/icon_broken.dart';
import '../../logic/app_bloc/app_bloc.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        IconBroken.Heart,
        color: postModel.likesUsersId!.contains(uId)
            ? Colors.pink[500]
            : Colors.grey,
      ),
      padding: EdgeInsets.zero,
      splashRadius: MediaQuery.sizeOf(context).width / 20,
      onPressed: () {
        AppBloc.get(context).likePost(postModel.postId);
      },
    );
  }
}
