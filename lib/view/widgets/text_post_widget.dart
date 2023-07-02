import 'package:chat_app/view/widgets/post_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextPostWidget extends StatelessWidget {
  const TextPostWidget({
    super.key,
    required this.widget,
  });

  final PostWidget widget;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        widget.postModel.post,
        style: TextStyle(fontSize: 16.sp),
        maxLines: 4,
      ),
    );
  }
}
