// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:chat_app/logic/app_bloc/app_bloc.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: ElevatedButton(
              child: Text('Verify Email'),
              onPressed: () async {
                await AppBloc.get(context).verifyEmail();
              },
            ),
          ),
        );
      },
    );
  }
}
