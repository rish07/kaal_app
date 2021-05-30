import 'dart:convert';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:kaal_bot/constants.dart';
import 'package:kaal_bot/views/dashboard.dart';
import 'package:kaal_bot/views/onboarding_os.dart';
import 'package:kaal_bot/widgets/action_button.dart';
import 'package:kaal_bot/widgets/sync_error_dialog.dart';
import 'package:page_transition/page_transition.dart';

class SecretPage extends StatefulWidget {
  const SecretPage({Key key}) : super(key: key);
  @override
  _SecretPageState createState() => _SecretPageState();
}

class _SecretPageState extends State<SecretPage> {
  String secretCode = "";
  Stream<QuerySnapshot> _userStream;

  Future sendMail() async {
    var headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'Basic OGUwMWYxMWY3YTJlNGY0MWZlOGU4NDFhY2IwZGUzNDI6OTVkOTA4OTU2YWE5MzYyNzFhNDVjZGNmNmM4MDQzNWY='
    };
    var request =
        http.Request('POST', Uri.parse('https://api.mailjet.com/v3.1/send'));
    request.body = json.encode({
      "Messages": [
        {
          "From": {"Email": "kavishrupesh@gmail.com", "Name": "Kaal"},
          "To": [
            {"Email": signedInUser.email, "Name": signedInUser.displayName}
          ],
          "Subject": "Welcome to Kaal Bot",
          "TextPart": "Here's your secret code: $secretCode"
        }
      ]
    });
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSecretCode();
  }

  Future<void> getSecretCode() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    users
        .where("userName", isEqualTo: signedInUser.displayName)
        .get()
        .then((doc) {
      setState(() {
        secretCode = doc.docs[0].id;
        loggedSecretCode = secretCode;
      });
    }).then((value) {
      users
          .doc(secretCode)
          .update({
            'userid': secretCode,
          })
          .then((value) => print("User ID Updated"))
          .catchError((error) => print("Failed to update user: $error"));
    }).then((value) {
      setState(
        () {
          _userStream = FirebaseFirestore.instance
              .collection("users")
              .doc(secretCode)
              .collection("activity")
              .snapshots();
        },
      );
    });
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
              StreamBuilder(
                  stream: _userStream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return Text('Something went wrong');
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text('Loading...');
                    }

                    return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                            mainAxisAlignment: MainAxisAlignment.start,
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
                                    Icons.email,
                                    color: Colors.white,
                                  ),
                                  onPressed: () async {
                                    await sendMail().then((value) {
                                      Fluttertoast.showToast(
                                          msg: 'Email Sent!');
                                    });
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
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                PageTransition(
                                    child: OnBoardingOS(),
                                    type: PageTransitionType.rightToLeft),
                              );
                            },
                            child: Container(
                              child: Text(
                                "See how to here",
                                style: TextStyle(
                                  color: violetColor,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          ActionButton(
                            title: "Continue",
                            size: size,
                            onTap: () {
                              print(snapshot.data.docs);
                              if (snapshot.data.docs.length != 0) {
                                Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Dashboard(
                                        userid: loggedSecretCode,
                                      ),
                                      type: PageTransitionType.rightToLeft),
                                );
                              } else {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SyncErrorDialog();
                                    });
                              }
                            },
                          )
                        ]);
                  })
            ],
          ),
        ),
      ]),
    );
  }
}
