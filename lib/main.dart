import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/layout/free_chat_layout.dart';
import 'package:free_chat/modules/chat_login_screen/chat_login_screen.dart';
import 'package:free_chat/modules/splash_screen/splash_view.dart';
import 'package:free_chat/shared/bloc_observer.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/cubit.dart';
import 'package:free_chat/shared/cubit/states.dart';
import 'package:free_chat/shared/network/local/cacheHelper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await CacheHelper.init();
  boardingFinished = CacheHelper.getData(key: 'boardingFinished');

  currentUserId = CacheHelper.getData(key: 'currentUserId');
  print('user id from main $currentUserId');
  //noImageSelected();

  //FirebaseAuth.instance.currentUser!.delete();
  //cubit.deleteUserData();

  BlocOverrides.runZoned(
    () {
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

/* void noImageSelected() {
  FirebaseStorage.instance
      .ref()
      .child('ProfileImages/avatar-1299805_960_720.png}')
      .getDownloadURL()
      .then((value) {
    noImage = value;
  });
} */

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FreeChatCubit()
        ..getUserData()
        ..getAllUsers(),
      child: BlocConsumer<FreeChatCubit, FreeChatStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.cyan,
            ),
            home: SplashView(),
          );
        },
      ),
    );
  }
}
