import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/layout/free_chat_layout.dart';
import 'package:free_chat/modules/chat_login_screen/cubit/states.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/network/local/cacheHelper.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ChatLoginCubit extends Cubit<ChatLoginStates> {
  ChatLoginCubit() : super(InitialChatLoginState());

  static ChatLoginCubit get(context) => BlocProvider.of(context);

  bool isPassword = true;
  IconData suffixIcon = Icons.visibility_off;

  void changePasswordVisibilityState() {
    isPassword = !isPassword;
    suffixIcon = isPassword ? Icons.visibility_off : Icons.visibility;
    emit(ChangePasswordVisibilityState());
  }

  void signInWithEmailAndPassword(context,
      {required String email, required String password}) {
    FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) {
      print('from log in  ${value.user!.uid}');
      emit(ChatLoginSuccessState(value.user!.uid));
    }).catchError((error) {
      emit(ChatLoginErrorState(error.toString()));
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
