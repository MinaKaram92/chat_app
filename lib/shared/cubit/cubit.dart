import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/models/message_model.dart';
import 'package:free_chat/models/user_model.dart';
import 'package:free_chat/modules/chat_login_screen/cubit/states.dart';
import 'package:free_chat/modules/profile_screen/profile_screen.dart';
import 'package:free_chat/modules/users_screen/users_screen.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/states.dart';
import 'package:image_picker/image_picker.dart';

class FreeChatCubit extends Cubit<FreeChatStates> {
  FreeChatCubit() : super(InitialFreeChatState());

  static FreeChatCubit get(context) => BlocProvider.of(context);

  List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: Icon(Icons.menu),
      label: 'Users',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ];

  List<Widget> screens = [UsersScreen(), ProfileScreen()];

  int currentIndex = 0;
  void changeBottomNavBarIndex(int index) {
    currentIndex = index;
    emit(ChangeBottomNavBarStatus());
  }

  UserModel? userModel;
  getUserData() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .get()
        .then((value) {
      userModel = UserModel.fromJson(value.data()!);
      emit(GetUserDataSuccessState());
    }).catchError((error) {
      emit(GetUserDataErrorState(error.toString()));
    });
  }

  File? profileImage;
  ImagePicker picker = ImagePicker();

  void getProfileImage({required ImageSource source}) async {
    await picker.pickImage(source: source).then((value) {
      XFile? pickedImage = value;
      if (pickedImage != null) {
        profileImage = File(pickedImage.path);
        emit(GetProfilePhotoSuccessState());
      }
    });
  }

  void cancelProfileImageUpdate() {
    profileImage = null;
    emit(CnacelProfilePhotoUpdateState());
  }

  void uploadProfileImage() {
    FirebaseStorage.instance
        .ref()
        .child('ProfileImages/$currentUserId/${basename(profileImage!.path)}')
        .putFile(profileImage!)
        .then((value) async {
      String imageUrl = await value.ref.getDownloadURL();
      updateUserData(fieldName: 'image', fieldData: imageUrl);
      emit(UploadingProfileImageSuccessState());
      profileImage = null;
    }).catchError((error) {
      emit(UploadingProfileImageErrorState(error.toString()));
    });
  }

  void updateUserData({
    required String fieldName,
    required String fieldData,
  }) {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .update({fieldName: fieldData}).then((value) {
      emit(UserDataUpdatedSuccessState(fieldName));
      getUserData();
    }).catchError((error) {
      print(error.toString());
      emit(UserDataUpdatedErrorState(error.toString()));
    });
  }

  void updateEmail(context, {required String email}) {
    print(FirebaseAuth.instance.currentUser!.email);
    FirebaseAuth.instance.currentUser!.updateEmail(email).then((value) {
      updateUserData(
        fieldData: email,
        fieldName: 'email',
      );
    }).catchError((error) {
      emit(EmailUpdatedErrorState(error.toString()));
    });
  }

  late List<UserModel> allUsers = [];

  void getAllUsers() {
    FirebaseFirestore.instance.collection('Users').get().then((value) {
      allUsers = [];
      value.docs.forEach((element) {
        if (element.id != currentUserId) {
          allUsers.add(UserModel.fromJson(element.data()));
        }
        emit(GetAllUserSuccessState());
      });
    }).catchError((error) {
      print(error.toString());
      emit(GetAllUserErrorState(error.toString()));
    });
  }

  void deleteUserData() {
    FirebaseFirestore.instance
        .collection('Users')
        .doc(currentUserId)
        .delete()
        .then((value) {
      emit(DeleteUserDataSuccessState());
    }).catchError((error) {
      emit(DeleteUserDataErrorState(error.toString()));
    });
  }

  void test() {
    print('hello mina');
  }
}
