import 'package:flutter/material.dart';
import 'package:kaal_bot/views/onboarding_mac.dart';
import 'package:kaal_bot/views/onboarding_win.dart';
import 'package:page_transition/page_transition.dart';

class OnBoardingOS extends StatefulWidget {
  const OnBoardingOS({Key key}) : super(key: key);

  @override
  _OnBoardingOSState createState() => _OnBoardingOSState();
}

class _OnBoardingOSState extends State<OnBoardingOS> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          child: Image.asset(
            "assets/os.png",
            fit: BoxFit.cover,
          ),
        ),
        Center(
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: OnboardindMac(), type: PageTransitionType.fade),
                ),
                child: Container(
                  height: 200,
                  width: 150,
                  child: Text(""),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  PageTransition(
                      child: OnboardindWin(), type: PageTransitionType.fade),
                ),
                child: Container(
                  height: 200,
                  width: 150,
                  child: Text(""),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
