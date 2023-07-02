// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  TextEditingController controller;

  bool isPassword;

  TextInputType? inputType;

  FormFieldValidator<String>? validator;

  IconData? suffixIconData;

  String? label;

  IconData? prefixIconData;

  ValueChanged<String>? onSubmitted;

  VoidCallback? onSuffixChange;

  InputField({
    Key? key,
    required this.controller,
    this.isPassword = false,
    this.onSuffixChange,
    this.inputType = TextInputType.emailAddress,
    required this.validator,
    this.label,
    this.prefixIconData,
    this.suffixIconData,
    this.onSubmitted,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: TextFormField(
        validator: validator,
        obscureText: isPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: inputType,
        onFieldSubmitted: onSubmitted,
        controller: controller,
        onSaved: (String? newValue) {
          controller.text = newValue!;
        },
        decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(prefixIconData),
            suffixIcon: IconButton(
                onPressed: onSuffixChange, icon: Icon(suffixIconData)),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))),
      ),
    );
  }
}
