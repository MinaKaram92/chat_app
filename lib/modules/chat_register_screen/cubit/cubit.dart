import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/models/user_model.dart';
import 'package:free_chat/modules/chat_register_screen/cubit/states.dart';

class ChatRegisterCubit extends Cubit<ChatRegisterStates> {
  ChatRegisterCubit() : super(InitialChatRegisterState());

  static ChatRegisterCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void changePasswordVisibilityState() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibilityState());
  }

  void registerUser({
    required String email,
    required String password,
    required String name,
    required String phone,
  }) {
    FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) {
      createUser(uId: value.user!.uid, name: name, email: email, phone: phone);
      emit(ChatRegisterUserSuccessState());
    }).catchError((error) {
      emit(ChatRegisterUserErrorState(error.toString()));
    });
  }

  void createUser({
    required String uId,
    required String name,
    required String phone,
    required String email,
  }) {
    UserModel userModel = UserModel(
      about: 'Write about yourself',
      email: email,
      image:
          'https://cdn.pixabay.com/photo/2016/04/01/10/11/avatar-1299805_960_720.png',
      name: name,
      phone: phone,
      uId: uId,
    );
    FirebaseFirestore.instance
        .collection('Users')
        .doc(uId)
        .set(userModel.toMap());
  }
}
