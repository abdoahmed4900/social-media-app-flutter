import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';

class PostUserImageWidget extends StatelessWidget {
  const PostUserImageWidget({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: MediaQuery.sizeOf(context).width / 15.5,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.cover, image: NetworkImage(postModel.userImage))),
      ),
    );
  }
}
