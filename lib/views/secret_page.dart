import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaal_bot/constants.dart';

class SecretPage extends StatefulWidget {
  final GoogleSignInAccount user;

  const SecretPage({Key key, this.user}) : super(key: key);
  @override
  _SecretPageState createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  bool _isCopied = false;
  String secretCode = "";

  Future<void> getSecretCode() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .where("userName", isEqualTo: widget.user.displayName)
        .get()
        .then((doc) {
      setState(() {
        secretCode = doc.docs[0].id;
      });
    });
  }

  @override
  void initState() {
    super.initState();

    getSecretCode();
  }

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
                    child: Text(secretCode),
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
                      onPressed: () async {
                        setState(() {
                          _isCopied = true;
                        });
                        ClipboardData data = ClipboardData(text: secretCode);
                        await Clipboard.setData(data);
                        Fluttertoast.showToast(msg: 'Copied to clipboard!');
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              Text(
                "Put this on your device CLI to begin the magic. Need help with it ?",
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
                  onPressed: () {
                    if (_isCopied) {
                    } else {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.only(
                                top: 24,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              title: Text("Sync Error"),
                              content: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                      right: 24,
                                      left: 24.0,
                                      bottom: 40,
                                    ),
                                    child: Text(
                                      "You haven’t initialized the “Secret Code in your CLI”. Please do that before you can continue",
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Center(
                                            child: Text(
                                              "Show me how",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.white),
                                            ),
                                            color: violetColor,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          child: Center(
                                            child: Text(
                                              "Okay, I'll do it",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border(
                                              top: BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  },
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
