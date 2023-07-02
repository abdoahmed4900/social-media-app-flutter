import 'package:chat_app/constants/methods.dart';
import 'package:chat_app/logic/register_bloc/register_bloc.dart';
import 'package:chat_app/view/screens/home_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../logic/app_bloc/app_bloc.dart';
import '../widgets/form_button.dart';
import '../widgets/input_field.dart';
// ignore_for_file: prefer_const_constructors, must_be_immutable

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  TextEditingController nameController = TextEditingController();

  TextEditingController phoneController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccessful) {
          showToast(
              message: 'Registered successfully',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.green);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeLayout()),
              (route) => false);
        } else if (state is RegisterError) {
          debugPrint('error in register listen');
          showToast(
              message: state.message,
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        final bloc = RegisterBloc.get(context);
        return Scaffold(
          appBar: AppBar(
              leading: IconButton(
                  onPressed: () {
                    AppBloc.get(context).isPassword = true;
                    AppBloc.get(context).passwordIcon = Icons.visibility;

                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back))),
          body: Form(
            key: formKey,
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.sp),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 58.625,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Sign up to connect with your friends',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 29.3125,
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
                      height: MediaQuery.sizeOf(context).height / 58.625,
                    ),
                    InputField(
                      label: 'Email Address',
                      controller: emailController,
                      prefixIconData: Icons.email,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Email Shouldn\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 58.625,
                    ),
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        final appBloc = AppBloc.get(context);
                        return InputField(
                          onSuffixChange: () =>
                              appBloc.changePasswordVisibility(),
                          suffixIconData: appBloc.passwordIcon,
                          isPassword: appBloc.isPassword,
                          label: 'Password',
                          controller: passController,
                          prefixIconData: Icons.lock,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password Shouldn\'t be Empty';
                            }
                            return null;
                          },
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 58.625,
                    ),
                    InputField(
                      label: 'Phone Number',
                      controller: phoneController,
                      inputType: TextInputType.phone,
                      prefixIconData: Icons.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Phone Number Shouldn\'t be Empty';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 29.2,
                    ),
                    state is RegisterLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : FormButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                bloc.register(
                                    phone: phoneController.text,
                                    context: context,
                                    email: emailController.text.trim(),
                                    password: passController.text,
                                    name: nameController.text);
                              }
                            },
                            buttonText: 'Register')
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
