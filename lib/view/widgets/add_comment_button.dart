import 'package:chat_app/view/widgets/post_widget.dart';
import 'package:flutter/material.dart';

import '../../logic/app_bloc/app_bloc.dart';

class AddCommentButton extends StatelessWidget {
  const AddCommentButton({
    super.key,
    required this.widget,
    required this.commentController,
  });

  final PostWidget widget;
  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: IconButton(
            onPressed: () {
              AppBloc.get(context).addComment(
                widget.postModel.postId,
                widget.index,
                commentController.text,
              );
              commentController.clear();
            },
            icon: const Icon(Icons.send)));
  }
}
