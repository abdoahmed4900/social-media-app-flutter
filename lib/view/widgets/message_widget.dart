// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/constants.dart';
import '../../logic/app_bloc/app_bloc.dart';
import '../../models/message.dart';
import 'image_message.dart';

class MessageWidget extends StatelessWidget {
  const MessageWidget({
    Key? key,
    required this.messageModel,
  }) : super(key: key);

  final MessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment:
          messageModel.senderId == uId ? Alignment.topRight : Alignment.topLeft,
      child: BlocBuilder<AppBloc, AppState>(
        builder: (context, state) {
          return Column(
            children: [
              if (messageModel.message != null)
                Container(
                    margin:
                        EdgeInsets.all(MediaQuery.sizeOf(context).width / 60),
                    decoration: BoxDecoration(
                        color: Colors.lightBlue,
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: Colors.lightBlue,
                            width: MediaQuery.sizeOf(context).width / 120)),
                    child: Text(messageModel.message!)),
              if (messageModel.photos != null)
                for (var i in messageModel.photos!)
                  ImageMessage(i: i, state: state)
            ],
          );
        },
      ),
    );
  }
}
