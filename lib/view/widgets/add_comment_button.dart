import 'package:chat_app/models/post.dart';
import 'package:flutter/material.dart';

import '../../logic/app_bloc/app_bloc.dart';

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({
    super.key,
    required this.postModel,
    required this.commentController,
  });

  final PostModel postModel;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: IconButton(
            onPressed: () {
              AppBloc.get(context).addComment(
                  postModel.postId, commentController.text, context);
              commentController.clear();
            },
            icon: const Icon(Icons.send)));
  }
}
