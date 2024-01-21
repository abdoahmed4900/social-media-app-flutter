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

class ChatScreen extends StatefulWidget {
  const ChatScreen({
    Key? key,
    required this.model,
  }) : super(key: key);

  final UserModel model;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController messageController = TextEditingController();

  final ScrollController controller = ScrollController();

  bool isKeyboardOpen = false;

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
                  backgroundImage: NetworkImage(widget.model.userImage),
                ),
                SizedBox(
                  width: MediaQuery.sizeOf(context).width / 48,
                ),
                Text(widget.model.name!)
              ],
            ),
          ),
          body: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            physics: AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(uId)
                      .collection('chats')
                      .doc(widget.model.uId)
                      .collection('messages')
                      .orderBy('dateTime')
                      .snapshots(),
                  builder: (context, snapshot) {
                    return SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.8,
                      child: ListView.builder(
                        controller: controller,
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
                      SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.7175,
                        child: TextFormField(
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
                                bloc
                                    .sendMessage(
                                        message: messageController.text,
                                        receiverId: widget.model.uId)
                                    .then((value) async {
                                  jumpToScreenEnd(context, controller);
                                });
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
                                bloc
                                    .sendPhoto(
                                        receiverId: widget.model.uId,
                                        source: source)
                                    .then((value) {
                                  jumpToScreenEnd(context, controller);
                                });
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
          ),
        );
      },
    );
  }
}
