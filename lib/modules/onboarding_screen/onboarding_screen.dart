import 'package:flutter/material.dart';
import 'package:free_chat/models/onboarding_model.dart';
import 'package:free_chat/modules/chat_login_screen/chat_login_screen.dart';
import 'package:free_chat/shared/components/components.dart';
import 'package:free_chat/shared/network/local/cacheHelper.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  var pageControllder = PageController();

  bool isBoardingFinished = false;

  List<OnboardingModel> onboardingModel = [
    OnboardingModel(
      image: 'assets/on_boarding1.jpg',
      title: 'Free Chat',
      text: 'A simple free chat app to communicate with  your mates',
    ),
    OnboardingModel(
      image: 'assets/chat_bubbles.png',
      text: 'Lets go to the free chat and communicate with friends',
    ),
  ];

  void gotoLayout() {
    CacheHelper.saveData(key: 'boardingFinished', value: isBoardingFinished)
        .then((value) {
      navigateAndFinish(context, ChatLoginScreen());
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: AlignmentDirectional.topEnd,
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      isBoardingFinished = true;
                    });
                    gotoLayout();
                  },
                  child: Text(
                    'Skip',
                    style: TextStyle(color: Colors.blue, fontSize: 20.0),
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  itemBuilder: (context, index) {
                    return buildOnBoardingScreen(
                        context, onboardingModel[index]);
                  },
                  physics: BouncingScrollPhysics(),
                  allowImplicitScrolling: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: onboardingModel.length,
                  controller: pageControllder,
                  onPageChanged: (index) {
                    if (index == onboardingModel.length - 1) {
                      setState(() {
                        isBoardingFinished = true;
                      });
                    } else {
                      setState(() {
                        isBoardingFinished = false;
                      });
                    }
                  },
                ),
              ),
              Row(
                children: [
                  Container(
                    height: 30.0,
                    child: SmoothPageIndicator(
                      controller: pageControllder,
                      count: onboardingModel.length,
                      axisDirection: Axis.horizontal,
                      effect: ExpandingDotsEffect(
                        expansionFactor: 3,
                        activeDotColor: Colors.blue,
                        dotColor: Colors.black,
                        spacing: 10.0,
                      ),
                    ),
                  ),
                  Spacer(),
                  FloatingActionButton(
                    child: Icon(
                      Icons.forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (isBoardingFinished) {
                        gotoLayout();
                      } else {
                        pageControllder.nextPage(
                          duration: Duration(seconds: 5),
                          curve: Curves.fastLinearToSlowEaseIn,
                        );
                      }
                    },
                    backgroundColor: Colors.blue,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildOnBoardingScreen(context, OnboardingModel model) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image(
          height: 250.0,
          image: AssetImage(model.image!),
        ),
        if (model.title != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0),
            child: Text(
              model.title!,
              style: Theme.of(context).textTheme.displayMedium!.copyWith(
                    color: Colors.blue,
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
        if (model.title == null)
          SizedBox(
            height: 30.0,
          ),
        Text(
          model.text!,
          textAlign: TextAlign.center,
          style:
              Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: 20.0),
        ),
      ],
    );
  }
}
