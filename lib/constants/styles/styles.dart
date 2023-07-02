import 'package:flutter/material.dart';

dynamic profileFont(context) => Theme.of(context)
    .textTheme
    .bodyLarge!
    .copyWith(fontSize: MediaQuery.sizeOf(context).width / 32);
