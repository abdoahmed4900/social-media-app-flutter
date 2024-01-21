// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/constants/styles/icon_broken.dart';
import 'package:chat_app/view/screens/login_screen.dart';
import 'package:chat_app/view/screens/search_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../constants/methods.dart';
import '../../logic/app_bloc/app_bloc.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text('Socio', style: TextStyle(fontFamily: 'IconBroken')),
            actions: [
              IconButton(
                  onPressed: () async {
                    logOut(bloc);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()),
                        (route) => false);
                  },
                  icon: Icon(IconBroken.Logout)),
              IconButton(onPressed: () {}, icon: Icon(IconBroken.Notification)),
              IconButton(
                  onPressed: () {
                    push(SearchPage(), context);
                  },
                  icon: Icon(IconBroken.Search)),
            ],
          ),
          body: StreamBuilder(
            stream: bloc.usersCollection.doc(uId).snapshots(),
            builder: (context, snapshot) => snapshot.hasData
                ? bloc.screens[bloc.bottomNavIndex]
                : LoginScreen(),
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: bloc.bottomNavIndex,
            onTap: (value) {
              bloc.changeBottomNavIndex(value, context);
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Message), label: 'Messages'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Paper_Upload), label: 'Post'),
              BottomNavigationBarItem(
                  icon: Icon(IconBroken.Profile), label: 'Profile'),
            ],
          ),
        );
      },
    );
  }
}
