import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaal_bot/constants.dart';
import 'package:kaal_bot/views/dashboard.dart';
import 'package:kaal_bot/views/landing_page.dart';
import 'package:page_transition/page_transition.dart';

class TeamView extends StatefulWidget {
  const TeamView({Key key}) : super(key: key);

  @override
  _TeamViewState createState() => _TeamViewState();
}

class _TeamViewState extends State<TeamView> {
  Stream<QuerySnapshot> _userStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _userStream = FirebaseFirestore.instance.collection("users").snapshots();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: size.height,
              width: size.width,
              child: Image.asset(
                "assets/home_bg.png",
                fit: BoxFit.cover,
              ),
            ),
            StreamBuilder(
              stream: _userStream,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshots) {
                if (snapshots.hasError) {
                  return Text('Something went wrong');
                }
                if (snapshots.connectionState == ConnectionState.waiting) {
                  return Text('Loading...');
                }
                if (snapshots.data.docs.length != 0) {
                  var activity = snapshots.data.docs;

                  return Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 30.0, horizontal: 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: size.height * 0.06,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Hey there, ${signedInUser.displayName.split(" ")[0]}!",
                              style: TextStyle(
                                fontSize: 32,
                              ),
                            ),
                            PopupMenuButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              onSelected: (value) async {
                                print("logout");
                                await FirebaseAuth.instance.signOut();
                                await GoogleSignIn().signOut();
                                Navigator.push(context, PageTransition(child: LandingPage(), type: PageTransitionType.rightToLeft),);
                              },
                              itemBuilder: (context) =>
                                  <PopupMenuEntry<String>>[
                                PopupMenuItem(
                                  value: "Logout",
                                  child: Text(
                                    'Logout',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  signedInUser.photoUrl,
                                  height: 40,
                                  width: 40,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.05,
                        ),
                        Image.asset("assets/search.png"),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Text(
                          "Employee List",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: size.height * 0.03,
                        ),
                        Container(
                          height: size.height * 0.5,
                          child: ListView.separated(
                            separatorBuilder:
                                (BuildContext context, int index) => Divider(
                              color: Colors.white,
                            ),
                            itemCount: activity.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        child: Dashboard(
                                            userid:
                                                activity[index].get("userid")),
                                        type: PageTransitionType.rightToLeft),
                                  );
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 3,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          activity[index].get("photoUrl"),
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        activity[index].get("userName"),
                                        style: TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container(
                  child: Center(
                    child: Text(
                      "No Data",
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
