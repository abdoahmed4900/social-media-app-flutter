import 'package:flutter/material.dart';

import '../../models/post.dart';

class OneImagePostWidget extends StatelessWidget {
  const OneImagePostWidget({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Image.network(
        postModel.postImages!.first,
        height: MediaQuery.sizeOf(context).height / 3.12,
        width: MediaQuery.sizeOf(context).width,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}
