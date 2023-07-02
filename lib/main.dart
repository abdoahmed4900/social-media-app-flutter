// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:chat_app/cache/cache_helper/cache_helper.dart';
import 'package:chat_app/constants/constants.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:chat_app/logic/notifications_helper/notifications_helper.dart';
import 'package:chat_app/view/screens/home_layout.dart';
import 'package:chat_app/view/screens/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'logic/login_bloc/login_bloc.dart';
import 'logic/register_bloc/register_bloc.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await CacheHelper.init();

  await NotificationsHelper.init();

  Widget widget;

  uId = CacheHelper.getString('uId');

  if (uId.isNotEmpty) {
    widget = HomeLayout();
  } else {
    widget = LoginScreen();
  }

  runApp(MyApp(
    widget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final Widget widget;

  MyApp({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      splitScreenMode: true,
      minTextAdapt: true,
      designSize: Size(360, 690),
      builder: (context, child) => MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => LoginBloc(),
          ),
          BlocProvider(
            create: (context) => RegisterBloc(),
          ),
          BlocProvider(
            create: (context) => AppBloc(context)..getUserData(context),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          darkTheme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed, elevation: 0),
          ),
          theme: ThemeData(
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
                type: BottomNavigationBarType.fixed, elevation: 0),
            primarySwatch: Colors.blue,
          ),
          home: widget,
        ),
      ),
    );
  }
}
