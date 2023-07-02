import 'package:chat_app/view/widgets/post_widget.dart';
import 'package:flutter/material.dart';

class OneImagePostWidget extends StatelessWidget {
  const OneImagePostWidget({
    super.key,
    required this.widget,
  });

  final PostWidget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Image.network(
        widget.postModel.postImages!.first,
        height: MediaQuery.sizeOf(context).height / 3.12,
        width: MediaQuery.sizeOf(context).width,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
