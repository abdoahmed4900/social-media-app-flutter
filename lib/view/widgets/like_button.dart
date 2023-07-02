import 'package:chat_app/view/widgets/post_widget.dart';
import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../constants/styles/icon_broken.dart';
import '../../logic/app_bloc/app_bloc.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({
    super.key,
    required this.widget,
  });

  final PostWidget widget;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        IconBroken.Heart,
        color: widget.postModel.likesUsersId!.contains(uId)
            ? Colors.pink[500]
            : Colors.grey,
      ),
      padding: EdgeInsets.zero,
      splashRadius: MediaQuery.sizeOf(context).width / 20,
      onPressed: () {
        AppBloc.get(context).likePost(widget.index, widget.postModel.postId);
      },
    );
  }
}
