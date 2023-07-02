// ignore_for_file: prefer_const_constructors

import 'package:chat_app/constants/methods.dart';
import 'package:chat_app/logic/firebase_helper/firebase_helper.dart';
import 'package:chat_app/view/screens/chat_screen.dart';
import 'package:chat_app/view/screens/other_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../logic/app_bloc/app_bloc.dart';

class SearchPage extends StatelessWidget {
  SearchPage({super.key});

  final TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);

        return Scaffold(
          appBar: AppBar(
            title: TextField(
              controller: searchController,
            ),
            leading: IconButton(
                onPressed: () {
                  bloc.searchResults.clear();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back)),
            actions: [
              IconButton(
                  onPressed: () {
                    FirebaseHelper.searchUser(
                        userName: searchController.text, bloc: bloc);
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          body: state is AppLoading
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: LinearProgressIndicator(),
                )
              : ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                        onTap: () {
                          if (bloc.bottomNavIndex == 1) {
                            push(
                                ChatScreen(
                                  model: bloc.searchResults[index],
                                ),
                                context);
                          } else {
                            if (bloc.searchResults[index].uId ==
                                bloc.userModel!.uId) {
                              Navigator.pop(context);
                              bloc.changeBottomNavIndex(3, context);
                            } else {
                              push(
                                  OtherProfileScreen(
                                      userModel: bloc.searchResults[index]),
                                  context);
                            }
                          }
                        },
                        title: Text(bloc.searchResults[index].name.toString()),
                        leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                                bloc.searchResults[index].userImage)),
                      ),
                  separatorBuilder: (context, index) =>
                      Divider(color: Colors.grey),
                  itemCount: bloc.searchResults.length),
        );
      },
    );
  }
}
