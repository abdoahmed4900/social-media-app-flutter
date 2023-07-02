import 'package:chat_app/view/widgets/show_comment.dart';
import 'package:flutter/material.dart';

import '../../models/post.dart';

class CommentsSection extends StatefulWidget {
  const CommentsSection({super.key, required this.postModel});

  final PostModel postModel;

  @override
  State<CommentsSection> createState() => _CommentsSectionState();
}

class _CommentsSectionState extends State<CommentsSection> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      for (int x = 0; x < widget.postModel.comments!.length; x++) ...[
        ShowComment(
          postModel: widget.postModel,
          currentIndex: x,
        )
      ],
    ]);
  }
}
