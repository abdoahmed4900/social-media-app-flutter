import 'package:flutter/material.dart';

class PickImageButton extends StatelessWidget {
  const PickImageButton({
    Key? key,
    required this.source,
    this.page,
  }) : super(key: key);

  final String source;

  final String? page;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.08,
          child: ElevatedButton(
              onPressed: (() async {
                Navigator.pop(context);
              }),
              child: Icon(source == 'Camera' ? Icons.camera_alt : Icons.photo)),
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height / 62.5,
        ),
        Text(source)
      ],
    );
  }
}
