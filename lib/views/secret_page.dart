import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:kaal_bot/constants.dart';

class SecretPage extends StatefulWidget {
  @override
  _SecretPageState createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(children: [
        Container(
          height: size.height,
          width: size.width,
          child: Image.asset(
            "assets/bg.png",
            fit: BoxFit.cover,
          ),
        ),
        Container(
          padding: EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: size.height * 0.07,
              ),
              Row(
                children: [
                  Image.asset("assets/logo.png"),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "Kaal",
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 40,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Text(
                "Here is the secret code for your productivity sprints",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 32,
                ),
              ),
              SizedBox(
                height: size.height * 0.3,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9),
                      color: Color(0xff2E323C),
                    ),
                    child: Text("abcdefgh-1234"),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: violetColor,
                        borderRadius: BorderRadius.circular(9)),
                    child: IconButton(
                      icon: Icon(
                        Icons.copy,
                        color: Colors.white,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                "Put this on your device CLI to begin the magic. need help with it ?",
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                "See how to here",
                style: TextStyle(
                  color: violetColor,
                  decoration: TextDecoration.underline,
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.27),
                child: MaterialButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  color: violetColor,
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Continue",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        Icon(
                          Icons.keyboard_arrow_right,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ]),
    );
  }
}
