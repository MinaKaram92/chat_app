import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/layout/free_chat_layout.dart';
import 'package:free_chat/modules/chat_login_screen/cubit/cubit.dart';
import 'package:free_chat/modules/chat_login_screen/cubit/states.dart';
import 'package:free_chat/modules/chat_register_screen/chat_register_screen.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/cubit.dart';
import 'package:free_chat/shared/network/local/cacheHelper.dart';

class ChatLoginScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatLoginCubit(),
      child: BlocConsumer<ChatLoginCubit, ChatLoginStates>(
        listener: (context, state) {
          if (state is ChatLoginErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          } else if (state is ChatLoginSuccessState) {
            navigateAndFinish(context, FreeChatLayout());
            currentUserId = state.userId;
            CacheHelper.saveData(key: 'currentUserId', value: state.userId);
            FreeChatCubit.get(context).getUserData();
            FreeChatCubit.get(context).getAllUsers();
          }
        },
        builder: (context, state) {
          ChatLoginCubit cubit = ChatLoginCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              title: Text(
                'Login',
                style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    CacheHelper.deleteData(key: 'boardingFinished')
                        .then((value) {
                      print('boardingFinished deleted successfully');
                    });
                  },
                  child: Text(
                    'Del Onboarding',
                    style: TextStyle(color: Colors.black),
                  ),
                )
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 40.0,
                      ),
                      defaultTextFormField(
                        hint: 'Email Address',
                        controller: emailController,
                        type: TextInputType.emailAddress,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Email must not be empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        hint: 'Password',
                        controller: passwordController,
                        type: TextInputType.visiblePassword,
                        suffix: cubit.suffixIcon,
                        isPassword: cubit.isPassword,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Password must not be empty';
                          }
                        },
                        suffixPressed: () {
                          cubit.changePasswordVisibilityState();
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultMaterialButton(
                        pressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.signInWithEmailAndPassword(context,
                                email: emailController.text,
                                password: passwordController.text);
                          }
                        },
                        text: 'login',
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Dont have an account'),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, ChatRegisterScreen());
                            },
                            child: Text('Register Now'),
                          )
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          cubit.signInWithGoogle().then((value) {
                            print('sign with google done successfully');
                          }).catchError((error) {
                            print(error.toString());
                          });
                        },
                        child: Text(
                          'Google sign in',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
