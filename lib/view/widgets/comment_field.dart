import 'package:flutter/material.dart';

class CommentField extends StatelessWidget {
  const CommentField({
    super.key,
    required this.commentController,
  });

  final TextEditingController commentController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.7,
      height: MediaQuery.sizeOf(context).height / 18.76,
      child: TextFormField(
        controller: commentController,
        decoration: InputDecoration(
            labelText: 'Write a Comment',
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(35))),
      ),
    );
  }
}
