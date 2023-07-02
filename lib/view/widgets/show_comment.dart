import 'package:flutter/material.dart';

import '../../models/post.dart';

class ShowComment extends StatelessWidget {
  final int currentIndex;

  const ShowComment(
      {Key? key, required this.postModel, required this.currentIndex})
      : super(key: key);

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.11,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: MediaQuery.sizeOf(context).width * 0.07,
            backgroundImage:
                NetworkImage(postModel.commentsUsersAvatars![currentIndex]),
          ),
          SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.06,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                postModel.commentsUsersNames![currentIndex],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.02,
              ),
              Text(
                postModel.comments![currentIndex],
                maxLines: 4,
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.03,
              )
            ],
          )
        ],
      ),
    );
  }
}
