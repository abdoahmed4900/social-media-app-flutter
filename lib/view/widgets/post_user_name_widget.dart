import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostUserNameWidget extends StatelessWidget {
  const PostUserNameWidget({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        postModel.userName,
        style: TextStyle(fontSize: 16.sp),
      ),
    );
  }
}
