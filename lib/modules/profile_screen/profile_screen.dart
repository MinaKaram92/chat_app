import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/models/pop_menu_item_model.dart';
import 'package:free_chat/modules/edit_about_screen/edit_about_screen.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/cubit.dart';
import 'package:free_chat/shared/cubit/states.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var phoneController = TextEditingController();
  var aboutController = TextEditingController();

  TapDownDetails? details;

  late List<ItemModel> menuItems;
  CustomPopupMenuController popMenuController = CustomPopupMenuController();

  List<PopupMenuEntry> popMenu = [
    PopupMenuItem(
        child: Icon(
          Icons.camera_alt,
        ),
        onTap: () {
          print('hello mina!');
        }),
    PopupMenuItem(child: Icon(Icons.browse_gallery)),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FreeChatCubit, FreeChatStates>(
      listener: (context, state) {
        if (state is UserDataUpdatedSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  '${state.fieldName..toUpperCase()} has updated successfully')));
        } else if (state is UserDataUpdatedErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.toString())));
        } else if (state is EmailUpdatedErrorState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(state.error.toString())));
        }
      },
      builder: (context, state) {
        FreeChatCubit cubit = FreeChatCubit.get(context);
        //print(cubit.userModel!.image);
        print(cubit.profileImage);
        return ConditionalBuilder(
          condition: cubit.userModel != null,
          builder: (context) {
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (FirebaseAuth.instance.currentUser!.emailVerified ==
                        false)
                      Row(
                        children: [
                          Text('check your mail'),
                          SizedBox(
                            width: 20.0,
                          ),
                          TextButton(
                            onPressed: () {
                              FirebaseAuth.instance.currentUser!
                                  .sendEmailVerification();
                            },
                            child: Text(
                              'Verify',
                            ),
                          ),
                        ],
                      ),
                    Center(
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 50.0,
                            backgroundImage:
                                NetworkImage('${cubit.userModel!.image}'),
                          ),
                          CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.cyan.shade200,
                            child: IconButton(
                                icon:
                                    Icon(Icons.camera_alt, color: Colors.black),
                                onPressed: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Container(
                                        color: Colors.cyan.shade200,
                                        width: double.infinity,
                                        height: 100.0,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              InkWell(
                                                onTap: () {
                                                  cubit.getProfileImage(
                                                      source:
                                                          ImageSource.camera);
                                                },
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.camera_alt,
                                                      size: 25.0,
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Text(
                                                      'Camera',
                                                      style: TextStyle(
                                                          fontSize: 20.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                width: 20.0,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  cubit.getProfileImage(
                                                      source:
                                                          ImageSource.gallery);
                                                },
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.photo_library,
                                                      size: 25.0,
                                                    ),
                                                    SizedBox(
                                                      height: 10.0,
                                                    ),
                                                    Text(
                                                      'Gallery',
                                                      style: TextStyle(
                                                          fontSize: 20.0),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                }),
                          )
                        ],
                      ),
                    ),
                    if (cubit.profileImage != null)
                      SizedBox(
                        height: 20.0,
                      ),
                    if (cubit.profileImage != null)
                      Row(
                        children: [
                          defaultMaterialButton(
                            pressed: () {
                              cubit.cancelProfileImageUpdate();
                            },
                            text: 'Cancel',
                            width: 120.0,
                            fontSize: 20.0,
                            textColor: Colors.black,
                            backgroundColor: Colors.cyan.shade200,
                          ),
                          Spacer(),
                          defaultMaterialButton(
                            pressed: () {
                              cubit.uploadProfileImage();
                            },
                            text: 'Update',
                            width: 120.0,
                            fontSize: 20.0,
                            textColor: Colors.black,
                            backgroundColor: Colors.cyan.shade200,
                          ),
                        ],
                      ),
                    profileItem(
                      context,
                      icon: Icons.person,
                      itemData: cubit.userModel!.name!,
                      updatePressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.updateUserData(
                            fieldName: 'name',
                            fieldData: nameController.text,
                          );
                        }
                      },
                      formFieldWidget: defaultTextFormField(
                        hint: 'Enter new name',
                        autoFocus: true,
                        type: TextInputType.name,
                        controller: nameController,
                        validate: (String value) {
                          if (value.isEmpty) {
                            return 'Please enter a valid name';
                          }
                        },
                      ),
                    ),
                    profileItemSeparator(),
                    profileItem(
                      context,
                      icon: Icons.email,
                      itemData: cubit.userModel!.email!,
                      updatePressed: () {
                        cubit.updateEmail(
                          context,
                          email: emailController.text,
                        );
                      },
                      formFieldWidget: defaultTextFormField(
                        hint: 'Enter new email',
                        autoFocus: true,
                        type: TextInputType.emailAddress,
                        controller: emailController,
                      ),
                    ),
                    profileItemSeparator(),
                    profileItem(
                      context,
                      icon: Icons.phone,
                      itemData: cubit.userModel!.phone!,
                      updatePressed: () {
                        if (formKey.currentState!.validate()) {
                          cubit.updateUserData(
                            fieldName: 'phone',
                            fieldData: phoneController.text,
                          );
                        }
                      },
                      formFieldWidget: defaultTextFormField(
                        hint: 'Enter new phone number',
                        autoFocus: true,
                        type: TextInputType.phone,
                        controller: phoneController,
                        validate: (String value) {
                          if (value.isEmpty ||
                              value.length < 11 ||
                              !value.startsWith('01')) {
                            return 'Please Enter valid phone number';
                          }
                        },
                      ),
                    ),
                    profileItemSeparator(),
                    InkWell(
                      onTap: () {
                        navigateTo(context, EditAboutScreen());
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Container(
                          width: double.infinity,
                          height: 120.0,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.cyan.shade200,
                                child: Icon(
                                  Icons.info,
                                  color: Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0, vertical: 10.0),
                                  child: Container(
                                    height: 100.0,
                                    width: double.infinity,
                                    child: Text(
                                      cubit.userModel!.about!,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              CircleAvatar(
                                radius: 20.0,
                                backgroundColor: Colors.cyan.shade200,
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          fallback: (context) => Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget profileItem(
    context, {
    required IconData icon,
    required String itemData,
    required Widget formFieldWidget,
    Function? updatePressed,
  }) {
    return InkWell(
      onTap: () async {
        await showCustomBottomSheet(
          context,
          formFieldWidget: formFieldWidget,
          updatePressed: updatePressed,
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.cyan.shade200,
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            SizedBox(
              width: 15.0,
            ),
            Text(
              itemData,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Spacer(),
            CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.cyan.shade200,
              child: Icon(
                Icons.edit,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget profileItemSeparator() {
    return Container(
      height: 1.0,
      width: double.infinity,
      color: Colors.black,
    );
  }

  var formKey = GlobalKey<FormState>();

  Future showCustomBottomSheet(
    context, {
    required Widget formFieldWidget,
    Function? updatePressed,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: Container(
            height: 181.0,
            child: Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      formFieldWidget,
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          defaultMaterialButton(
                            backgroundColor: Colors.cyan.shade200,
                            textColor: Colors.black,
                            width: 100.0,
                            fontSize: 15.0,
                            pressed: () {
                              Navigator.of(context).pop();
                            },
                            text: 'Cancel',
                          ),
                          Spacer(),
                          defaultMaterialButton(
                            backgroundColor: Colors.cyan.shade200,
                            textColor: Colors.black,
                            width: 100.0,
                            fontSize: 15.0,
                            pressed: () {
                              updatePressed!();
                            },
                            text: 'Update',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
