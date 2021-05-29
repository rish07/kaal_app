import 'package:flutter/material.dart';
import 'package:kaal_bot/constants.dart';
import 'package:kaal_bot/views/dashboard.dart';
import 'package:kaal_bot/widgets/action_button.dart';
import 'package:kaal_bot/widgets/instruction.dart';
import 'package:page_transition/page_transition.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';

class OnboardindMac extends StatefulWidget {
  const OnboardindMac({Key key}) : super(key: key);

  @override
  _OnboardindMacState createState() => _OnboardindMacState();
}

class _OnboardindMacState extends State<OnboardindMac> {
  final PageController _controller = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  _buildCircleIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CirclePageIndicator(
        itemCount: 3,
        currentPageNotifier: _currentPageNotifier,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          height: size.height,
          width: size.width,
          child: Image.asset(
            "assets/common_bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Container(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(24),
                margin: EdgeInsets.only(top: size.height * 0.2),
                height: size.height * 0.55,
                width: size.width,
                child: PageView(
                  onPageChanged: (int index) {
                    _currentPageNotifier.value = index;
                  },
                  controller: _controller,
                  children: [
                    Instructions(
                      size: size,
                      imagePath: "assets/mac_1.png",
                      text: "Enter secret code and register with KAAL",
                    ),
                    Instructions(
                      size: size,
                      imagePath: "assets/mac_2.png",
                      text: "Enter check-in command to start monitoring",
                    ),
                    Instructions(
                      size: size,
                      imagePath: "assets/mac_3.png",
                      text: "Enter check-out command to stop monitoring",
                    ),
                  ],
                ),
              ),
              _buildCircleIndicator(),
              SizedBox(height: size.height * 0.1),
              ActionButton(
                size: size,
                title: 'Next Step',
                onTap: () {
                  if (_currentPageNotifier.value < 2) {
                    _controller.animateToPage(_currentPageNotifier.value + 1,
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn);
                  } else {
                    Navigator.push(
                      context,
                      PageTransition(
                          child: Dashboard(
                            userid: loggedSecretCode,
                          ),
                          type: PageTransitionType.rightToLeft),
                    );
                  }
                },
              )
            ],
          ),
        ),
      ],
    );
  }
}
