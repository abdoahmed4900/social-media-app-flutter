import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/post.dart';

class TextPostWidget extends StatelessWidget {
  const TextPostWidget({
    super.key,
    required this.postModel,
  });

  final PostModel postModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        postModel.post,
        style: TextStyle(fontSize: 16.sp),
        maxLines: 4,
      ),
    );
  }
}
