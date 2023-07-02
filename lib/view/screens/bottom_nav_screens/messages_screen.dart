// ignore_for_file: prefer_const_constructors

import 'package:chat_app/constants/methods.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:chat_app/view/screens/search_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../logic/app_bloc/app_bloc.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AppBloc, AppState>(
        listener: (context, state) {},
        builder: (context, state) {
          // final bloc = AppBloc.get(context);

          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection('users').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final data = snapshot.data;
                return ListView.separated(
                  itemBuilder: (context, index) {
                    UserModel model =
                        UserModel.fromMap(data!.docs[index].data());
                    return ListTile(
                      contentPadding: EdgeInsets.all(8),
                      onTap: () {
                        push(ChatScreen(model: model), context);
                      },
                      title:
                          Text(model.name!, style: TextStyle(fontSize: 20.sp)),
                      leading: CircleAvatar(
                        radius: 32,
                        backgroundImage: NetworkImage(model.userImage),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.sizeOf(context).width / 30,
                        vertical: MediaQuery.sizeOf(context).width / 60),
                    child: Divider(
                      height: MediaQuery.sizeOf(context).height * 0.004,
                      color: Colors.grey,
                    ),
                  ),
                  itemCount: snapshot.data!.docs.isNotEmpty
                      ? snapshot.data!.docs.length
                      : 0,
                );
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(SearchPage(), context);
        },
        child: Icon(Icons.chat),
      ),
    );
  }
}
