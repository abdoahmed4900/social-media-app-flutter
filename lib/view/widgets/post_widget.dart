// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_build_context_synchronously
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:chat_app/models/post.dart';
import 'package:chat_app/view/widgets/post_settings_widget.dart';
import 'package:chat_app/view/widgets/post_user_image_widget.dart';
import 'package:chat_app/view/widgets/post_user_name_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/styles/icon_broken.dart';
import 'add_comment_button.dart';
import 'comment_field.dart';
import 'comment_section.dart';
import 'like_button.dart';
import 'multi_image_post_view.dart';
import 'one_image_and_text_post.dart';
import 'one_image_post_widget.dart';
import 'text_post_widget.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({
    Key? key,
    required this.postModel,
    required this.index,
  }) : super(key: key);

  final PostModel postModel;
  final int index;

  @override
  State<PostWidget> createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  color: Colors.grey[100],
                  height: MediaQuery.sizeOf(context).height / 11,
                  child: Row(
                    children: [
                      PostUserImageWidget(widget: widget),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 50,
                      ),
                      PostUserNameWidget(widget: widget),
                      Spacer(),
                      if (widget.postModel.userId == uId)
                        PostSettingsWidget(widget: widget)
                    ],
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 37,
                ),
                if (widget.postModel.post.isNotEmpty &&
                    widget.postModel.postImages!.isEmpty)
                  TextPostWidget(widget: widget),
                if (widget.postModel.postImages!.isNotEmpty &&
                    widget.postModel.post.isEmpty &&
                    widget.postModel.postImages!.length == 1)
                  OneImagePostWidget(widget: widget),
                if (widget.postModel.postImages!.isNotEmpty &&
                    widget.postModel.post.isNotEmpty &&
                    widget.postModel.postImages!.length == 1)
                  OneImageAndTextPost(widget: widget),
                if (widget.postModel.postImages!.isNotEmpty &&
                    widget.postModel.post.isEmpty &&
                    widget.postModel.postImages!.length > 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MultiImagePostView(images: widget.postModel.postImages!)
                    ],
                  ),
                if (widget.postModel.postImages!.isNotEmpty &&
                    widget.postModel.post.isNotEmpty &&
                    widget.postModel.postImages!.length > 1)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.postModel.post,
                      ),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 46.9,
                      ),
                      MultiImagePostView(images: widget.postModel.postImages!)
                    ],
                  ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 73,
                      ),
                      Text(widget.postModel.likes.toString()),
                      LikeButton(
                        widget: widget,
                      ),
                      Spacer(),
                      Text(widget.postModel.commentsNumber.toString()),
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width / 79,
                      ),
                      Icon(IconBroken.Chat),
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height / 15,
                      ),
                    ],
                  ),
                ),
                CommentsSection(postModel: widget.postModel),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 46.9,
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundImage: NetworkImage(
                          AppBloc.get(context).userModel!.userImage),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).width / 48,
                    ),
                    CommentField(commentController: commentController),
                    AddCommentButton(
                        widget: widget, commentController: commentController)
                  ],
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 93.8,
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
