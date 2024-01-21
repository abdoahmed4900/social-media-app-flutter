import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';

class OneImageAndTextPost extends StatelessWidget {
  const OneImageAndTextPost({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          postModel.post,
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 46.9,
        ),
        Material(
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Image.network(
              postModel.postImages!.first,
              width: MediaQuery.sizeOf(context).width,
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
  }
}
