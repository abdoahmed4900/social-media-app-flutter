// ignore_for_file: prefer_const_constructors, must_be_immutable

import 'package:chat_app/constants/methods.dart';
import 'package:chat_app/logic/login_bloc/login_bloc.dart';
import 'package:chat_app/view/screens/home_layout.dart';
import 'package:chat_app/view/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../logic/app_bloc/app_bloc.dart';
import '../widgets/form_button.dart';
import '../widgets/input_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  TextEditingController emailController = TextEditingController();

  TextEditingController passController = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is LoginSuccessful) {
          showToast(
              message: 'Login is Successful!',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.green);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeLayout()),
              (route) => false);
        } else if (state is LoginError) {
          showToast(
              message: 'Login is not successful',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: Colors.red);
        }
      },
      builder: (context, state) {
        final bloc = LoginBloc.get(context);
        return Scaffold(
          appBar: AppBar(),
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
                        'LOGIN',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 24.sp),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 58.4,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        'Login to connect with your friends',
                        style: TextStyle(fontSize: 18.sp, color: Colors.grey),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 29.3125,
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
                      height: MediaQuery.sizeOf(context).height / 58.4,
                    ),
                    BlocBuilder<AppBloc, AppState>(
                      builder: (context, state) {
                        final appBloc = AppBloc.get(context);
                        return InputField(
                          label: 'Password',
                          onSubmitted: ((value) {
                            if (formKey.currentState!.validate()) {
                              bloc.login(
                                  context: context,
                                  email: emailController.text,
                                  password: passController.text);
                            }
                          }),
                          controller: passController,
                          prefixIconData: Icons.lock,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password Shouldn\'t be Empty';
                            }
                            return null;
                          },
                          suffixIconData: appBloc.passwordIcon,
                          isPassword: appBloc.isPassword,
                          onSuffixChange: () =>
                              appBloc.changePasswordVisibility(),
                        );
                      },
                    ),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 29.2,
                    ),
                    state is LoginLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : FormButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                bloc.login(
                                    context: context,
                                    email: emailController.text.trim(),
                                    password: passController.text);
                              }
                            },
                            buttonText: 'Login In'),
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height / 29.2,
                    ),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Don\'t have an account?'),
                          TextButton(
                              onPressed: () {
                                AppBloc.get(context).isPassword = true;
                                AppBloc.get(context).passwordIcon =
                                    Icons.visibility;
                                push(RegisterScreen(), context);
                              },
                              child: Text('Sign Up'))
                        ],
                      ),
                    )
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
