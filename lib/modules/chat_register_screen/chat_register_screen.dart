import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/modules/chat_login_screen/chat_login_screen.dart';
import 'package:free_chat/modules/chat_register_screen/cubit/cubit.dart';
import 'package:free_chat/modules/chat_register_screen/cubit/states.dart';
import 'package:free_chat/shared/components/components.dart';

class ChatRegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ChatRegisterCubit(),
      child: BlocConsumer<ChatRegisterCubit, ChatRegisterStates>(
        listener: (context, state) {
          if (state is ChatRegisterUserSuccessState) {
            navigateTo(context, ChatLoginScreen());
          } else if (state is ChatRegisterUserErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
              ),
            );
          }
        },
        builder: (context, state) {
          ChatRegisterCubit cubit = ChatRegisterCubit.get(context);
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      defaultTextFormField(
                        type: TextInputType.emailAddress,
                        controller: emailController,
                        hint: 'email',
                        prefix: Icons.email,
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
                        type: TextInputType.name,
                        controller: nameController,
                        hint: 'name',
                        prefix: Icons.person,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'name must not be empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        type: TextInputType.phone,
                        controller: phoneController,
                        hint: 'phone',
                        prefix: Icons.phone,
                        validate: (String value) {
                          if (value.isEmpty ||
                              value.length < 11 ||
                              !value.startsWith('01')) {
                            return 'Please Enter valid phone number';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultTextFormField(
                        type: TextInputType.visiblePassword,
                        controller: passwordController,
                        hint: 'password',
                        prefix: Icons.lock,
                        isPassword: cubit.isPassword,
                        suffix: cubit.suffixIcon,
                        suffixPressed: () {
                          cubit.changePasswordVisibilityState();
                        },
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'password must not be empty';
                          }
                        },
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultMaterialButton(
                        pressed: () {
                          if (formKey.currentState!.validate()) {
                            cubit.registerUser(
                              email: emailController.text,
                              password: passwordController.text,
                              name: nameController.text,
                              phone: phoneController.text,
                            );
                          }
                        },
                        text: 'Sign up',
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
