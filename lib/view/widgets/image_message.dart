import 'package:flutter/material.dart';

import '../../logic/app_bloc/app_bloc.dart';

class ImageMessage extends StatelessWidget {
  const ImageMessage({
    super.key,
    required this.i,
    required this.state,
  });

  final AppState state;

  final String i;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: MediaQuery.sizeOf(context).height / 60,
          horizontal: MediaQuery.sizeOf(context).width / 60),
      width: MediaQuery.sizeOf(context).width * 0.32,
      height: MediaQuery.sizeOf(context).height * 0.24,
      decoration: BoxDecoration(
          image: DecorationImage(image: NetworkImage(i), fit: BoxFit.fill),
          color: Colors.lightBlue,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: Colors.lightBlue,
              width: MediaQuery.sizeOf(context).width / 120)),
    );
  }
}
