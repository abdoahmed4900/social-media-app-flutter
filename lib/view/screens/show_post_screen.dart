// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:chat_app/models/post.dart';

import '../../constants/constants.dart';
import '../../constants/styles/icon_broken.dart';
import '../../logic/app_bloc/app_bloc.dart';
import '../widgets/add_comment_button.dart';
import '../widgets/comment_field.dart';
import '../widgets/comment_section.dart';
import '../widgets/like_button.dart';
import '../widgets/multi_image_post_view.dart';
import '../widgets/one_image_and_text_post.dart';
import '../widgets/one_image_post_widget.dart';
import '../widgets/post_settings_widget.dart';
import '../widgets/post_user_image_widget.dart';
import '../widgets/post_user_name_widget.dart';
import '../widgets/text_post_widget.dart';

class ShowPost extends StatelessWidget {
  ShowPost({
    Key? key,
    required this.postModel,
  }) : super(key: key);

  final PostModel postModel;

  final commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
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
                    PostUserImageWidget(postModel: postModel),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 50,
                    ),
                    PostUserNameWidget(postModel: postModel),
                    const Spacer(),
                    if (postModel.userId == uId)
                      PostSettingsWidget(
                        postModel: postModel,
                      )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 37,
              ),
              if (postModel.post.isNotEmpty && postModel.postImages!.isEmpty)
                TextPostWidget(postModel: postModel),
              if (postModel.postImages!.isNotEmpty &&
                  postModel.post.isEmpty &&
                  postModel.postImages!.length == 1)
                OneImagePostWidget(
                  postModel: postModel,
                ),
              if (postModel.postImages!.isNotEmpty &&
                  postModel.post.isNotEmpty &&
                  postModel.postImages!.length == 1)
                OneImageAndTextPost(postModel: postModel),
              if (postModel.postImages!.isNotEmpty &&
                  postModel.post.isEmpty &&
                  postModel.postImages!.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [MultiImagePostView(images: postModel.postImages!)],
                ),
              if (postModel.postImages!.isNotEmpty &&
                  postModel.post.isNotEmpty &&
                  postModel.postImages!.length > 1)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      postModel.post,
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 46.9,
                    ),
                    MultiImagePostView(images: postModel.postImages!)
                  ],
                ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 73,
                    ),
                    Text(postModel.likes.toString()),
                    LikeButton(
                      postModel: postModel,
                    ),
                    const Spacer(),
                    Text(postModel.commentsNumber.toString()),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width / 79,
                    ),
                    const Icon(IconBroken.Chat),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 15,
                    ),
                  ],
                ),
              ),
              CommentsSection(postModel: postModel),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 46.9,
              ),
              Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage:
                        NetworkImage(AppBloc.get(context).userModel!.userImage),
                  ),
                  SizedBox(
                    height: MediaQuery.sizeOf(context).width / 48,
                  ),
                  CommentField(commentController: commentController),
                  AddCommentButton(
                    commentController: commentController,
                    postModel: postModel,
                  )
                ],
              ),
              SizedBox(
                height: MediaQuery.sizeOf(context).height / 93.8,
              )
            ],
          ),
        ),
      ),
    );
  }
}
