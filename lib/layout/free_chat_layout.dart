import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:free_chat/modules/chat_login_screen/chat_login_screen.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';
import 'package:free_chat/shared/cubit/cubit.dart';
import 'package:free_chat/shared/cubit/states.dart';
import 'package:free_chat/shared/network/local/cacheHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreeChatLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FreeChatCubit, FreeChatStates>(
      listener: (context, state) {},
      builder: (context, state) {
        FreeChatCubit cubit = FreeChatCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.cyan.shade200,
            title: Text(
              'Free Chat',
              style: TextStyle(color: Colors.black),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  CacheHelper.deleteData(key: 'currentUserId').then((value) {
                    print('currentUserId deleted successfully');
                    currentUserId = null;
                    navigateAndFinish(context, ChatLoginScreen());
                  });
                },
                child: Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            items: cubit.items,
            type: BottomNavigationBarType.fixed,
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottomNavBarIndex(index);
            },
            backgroundColor: Colors.cyan.shade200,
            selectedItemColor: Colors.black,
            unselectedItemColor: Colors.white,
          ),
        );
      },
    );
  }
}
