// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_unnecessary_containers
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:chat_app/constants/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/models/message.dart';

import '../../constants/constants.dart';
import '../../logic/app_bloc/app_bloc.dart';
import '../../models/user.dart';
import '../widgets/message_widget.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final TextEditingController messageController = TextEditingController();

  final UserModel model;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);
        return Scaffold(
          appBar: AppBar(
            leadingWidth: MediaQuery.sizeOf(context).width * 0.05,
            title: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(model.userImage),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 48,
                ),
                Text(model.name!)
              ],
            ),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(uId)
                    .collection('chats')
                    .doc(model.uId)
                    .collection('messages')
                    .orderBy('dateTime')
                    .snapshots(),
                builder: (context, snapshot) {
                  return Expanded(
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) => MessageWidget(
                          messageModel: MessageModel.fromMap(
                              snapshot.data!.docs[index].data())),
                      itemCount:
                          snapshot.hasData ? snapshot.data!.docs.length : 0,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                              child: IconButton(
                            onPressed: () {
                              bloc.sendMessage(
                                  message: messageController.text,
                                  receiverId: model.uId);
                              messageController.clear();
                            },
                            icon: Icon(Icons.send),
                            splashRadius: 30,
                          )),
                          SizedBox(
                            width: MediaQuery.sizeOf(context).width * 0.01,
                          ),
                          CircleAvatar(
                              child: IconButton(
                            onPressed: () async {
                              final source = await pickImage(context);
                              bloc.sendPhoto(
                                  receiverId: model.uId, source: source);
                            },
                            icon: Icon(Icons.photo),
                            splashRadius: 30,
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
