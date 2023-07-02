// ignore_for_file: must_be_immutable, prefer_const_constructors

import 'package:chat_app/logic/app_bloc/app_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/form_button.dart';
import '../widgets/input_field.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen(
      {super.key, required this.name, required this.bio, required this.phone});

  final String name;

  final String bio;

  final String phone;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController phoneController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController bioController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    nameController.text = widget.name;
    phoneController.text = widget.phone;
    bioController.text = widget.bio;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppBloc, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        final bloc = AppBloc.get(context);
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Edit Your Profile',
              style: TextStyle(fontSize: 16.sp, color: Colors.white),
            ),
          ),
          body: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 30,
                ),
                InputField(
                  label: 'Name',
                  controller: nameController,
                  prefixIconData: Icons.person,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name Shouldn\'t be Empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 58.4,
                ),
                InputField(
                  prefixIconData: Icons.email,
                  label: 'Phone',
                  controller: phoneController,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Phone Shouldn\'t be Empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 29.2,
                ),
                InputField(
                  label: 'Bio',
                  controller: bioController,
                  prefixIconData: Icons.info,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Bio Shouldn\'t be Empty';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: MediaQuery.sizeOf(context).height / 25,
                ),
                FormButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        bloc.editProfile(
                            name: nameController.text,
                            phone: phoneController.text,
                            bio: bioController.text,
                            context: context);
                      }
                    },
                    buttonText: 'Submit'),
              ],
            ),
          ),
        );
      },
    );
  }
}
