import 'package:flutter/material.dart';
import 'package:free_chat/layout/free_chat_layout.dart';
import 'package:free_chat/modules/chat_login_screen/chat_login_screen.dart';
import 'package:free_chat/modules/chat_login_screen/cubit/cubit.dart';
import 'package:free_chat/modules/onboarding_screen/onboarding_screen.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/components/constants.dart';

class SplashView extends StatefulWidget {
  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration(seconds: 5),
      () {
        /* navigateTo(context, OnboardingScreen());
        print('boardingFinished : $boardingFinished'); */
        if (boardingFinished != null) {
          if (currentUserId != null) {
            navigateAndFinish(context, FreeChatLayout());
          } else {
            navigateAndFinish(context, ChatLoginScreen());
          }
        } else {
          navigateAndFinish(context, OnboardingScreen());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Shop App',
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                      color: Colors.blue,
                    ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Image(
                  height: 200.0,
                  image: AssetImage('assets/splash.jpg'),
                ),
              ),
              Text(
                'Welcome\n to\n Free Chat',
                textAlign: TextAlign.center,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(color: Colors.blue, fontSize: 30.0),
              ),
              SizedBox(
                height: 50.0,
              ),
              CircularProgressIndicator(
                color: Colors.blue,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
