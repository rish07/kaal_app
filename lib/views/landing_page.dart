import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaal_bot/constants.dart';
import 'package:kaal_bot/google_sign_in.dart';
import 'package:kaal_bot/views/secret_page.dart';
import 'package:kaal_bot/views/team_view.dart';
import 'package:page_transition/page_transition.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  CollectionReference admins = FirebaseFirestore.instance.collection('admins');

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
        FutureBuilder(
            future: admins.doc("lagdb30M5OEANHQZrHsn").get(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text("Something went wrong");
              }

              if (snapshot.hasData && !snapshot.data.exists) {
                return Text("Document does not exist");
              }
              if (snapshot.connectionState == ConnectionState.done) {
                Map<String, dynamic> data = snapshot.data.data();
                return Container(
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
                        "Be productive\nwithout interrupting your workflow",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 32,
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.35,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.15),
                        child: MaterialButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(12),
                          color: Color(0xff2A2D36),
                          onPressed: () async {
                            GoogleSignInAccount user = await signInWithGoogle();
                            setState(() {
                              signedInUser = user;
                            });

                            Navigator.push(
                              context,
                              PageTransition(
                                child: data['admins'].contains(user.email)
                                    ? TeamView()
                                    : SecretPage(),
                                type: PageTransitionType.rightToLeft,
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset("assets/google.png"),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Sign In with Google",
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }
              return Text("loading");
            })
      ]),
    );
  }
}
