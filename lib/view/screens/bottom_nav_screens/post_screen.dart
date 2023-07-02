// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:io';

import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../constants/methods.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final postController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    AppBloc.get(context).pickedPostImages.clear();
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back)),
            ),
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(children: [
                TextFormField(
                  controller: postController,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'What Do You Think?',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 46.9,
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 23.45,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        if (AppBloc.get(context).pickedPostImages.isEmpty) {
                          AppBloc.get(context)
                              .postWithoutImage(post: postController.text)
                              .then((value) {
                            Navigator.pop(context);
                          });
                        } else if (AppBloc.get(context)
                            .pickedPostImages
                            .isNotEmpty) {
                          AppBloc.get(context)
                              .postWithImage(post: postController.text)
                              .then((value) {
                            AppBloc.get(context).pickedPostImages.clear();
                            Navigator.pop(context);
                          });
                        }
                      },
                      child: Text('Post')),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 93.8,
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height / 23.45,
                  decoration: BoxDecoration(
                      border: Border.all(width: 0.05),
                      borderRadius: BorderRadius.circular(5)),
                  child: TextButton(
                      onPressed: () async {
                        final source = await pickImage(context);

                        await pickPostImages(source, AppBloc.get(context));
                      },
                      child: Text('Add Photos')),
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 23.45,
                ),
                if (AppBloc.get(context).pickedPostImages.isNotEmpty)
                  Align(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                        runSpacing: MediaQuery.sizeOf(context).width / 24,
                        spacing: MediaQuery.sizeOf(context).width / 24,
                        direction: Axis.horizontal,
                        children: [
                          for (int x = 0;
                              x < AppBloc.get(context).pickedPostImages.length;
                              x++) ...[
                            Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.topLeft,
                              children: [
                                Image.file(
                                  File(
                                      AppBloc.get(context).pickedPostImages[x]),
                                  width: MediaQuery.sizeOf(context).width / 4.8,
                                  height:
                                      MediaQuery.sizeOf(context).height / 6.25,
                                  fit: BoxFit.cover,
                                ),
                                Positioned(
                                  left: -2,
                                  top: -MediaQuery.sizeOf(context).height / 70,
                                  child: CircleAvatar(
                                    child: IconButton(
                                      icon: Icon(Icons.close),
                                      onPressed: () {
                                        AppBloc.get(context)
                                            .pickedPostImages
                                            .removeAt(x);
                                        AppBloc.get(context).add(AddPost());
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ]),
                  ),
              ]),
            )));
      },
    );
  }
}
