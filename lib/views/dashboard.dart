import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kaal_bot/constants.dart';
import 'package:page_transition/page_transition.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'landing_page.dart';

class Dashboard extends StatefulWidget {
  final String userid;
  const Dashboard({Key key, @required this.userid}) : super(key: key);
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  Stream<QuerySnapshot> _dataStream;
  double totalWork = 0;
  CollectionReference adminRef =
      FirebaseFirestore.instance.collection('admins');
  List admins;
  DocumentSnapshot temp;

  @override
  void initState() {
    super.initState();
    setState(
      () {
        _dataStream = FirebaseFirestore.instance
            .collection('users')
            .doc(widget.userid)
            .collection('activity')
            .orderBy(
              "timestamp",
              descending: true,
            )
            .snapshots();
      },
    );
    getAdmins();
  }

  DateTime currentBackPressTime;

  Future getAdmins() async {
    temp = await adminRef.doc("lagdb30M5OEANHQZrHsn").get();
    setState(() {
      admins = temp.get("admins");
    });
  }

  Future<bool> onWillPop() {
    if (admins.contains(signedInUser.email)) {
      return Future.value(true);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(
            msg: "Press again to exit the app",
            backgroundColor: Colors.white,
            textColor: Colors.black);
        return Future.value(false);
      }
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      return Future.value(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
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
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 32),
                child: Column(
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
                            Navigator.push(
                              context,
                              PageTransition(
                                  child: LandingPage(),
                                  type: PageTransitionType.rightToLeft),
                            );
                          },
                          itemBuilder: (context) => <PopupMenuEntry<String>>[
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
                      height: size.height * 0.04,
                    ),
                    StreamBuilder(
                      stream: _dataStream,
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshots) {
                        if (snapshots.hasError) {
                          return Text('Something went wrong');
                        }
                        if (snapshots.connectionState ==
                            ConnectionState.waiting) {
                          return Text('Loading...');
                        }
                        if (snapshots.data.docs.length != 0) {
                          var activity = snapshots.data.docs[0].get('data');

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    "Total time: ",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    "${(activity.values.toList().fold(0, (p, c) => p + c)).toStringAsFixed(2)} Secs",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                              ),
                              AspectRatio(
                                aspectRatio: 1.23,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(18)),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xff202020),
                                        Color(0xff474747),
                                      ],
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12, right: 16.0, left: 6.0),
                                          child: Center(
                                            child: Container(
                                              child: SfCartesianChart(
                                                // Initialize category axis
                                                primaryYAxis: CategoryAxis(
                                                  title: AxisTitle(
                                                    text: 'Secs',
                                                    textStyle: TextStyle(
                                                        fontFamily: 'Roboto',
                                                        fontSize: 12,
                                                        fontStyle:
                                                            FontStyle.italic,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ),
                                                primaryXAxis: CategoryAxis(),
                                                series: <
                                                    LineSeries<ActivityData,
                                                        String>>[
                                                  LineSeries<ActivityData,
                                                      String>(
                                                    // Bind data source
                                                    dataSource: List<
                                                            ActivityData>.generate(
                                                        activity.length,
                                                        (int index) {
                                                      return ActivityData(
                                                          activity.keys
                                                              .toList()[index],
                                                          double.parse(activity
                                                              .values
                                                              .toList()[index]
                                                              .toString(),),);
                                                    },),
                                                    xValueMapper:
                                                        (ActivityData sales,
                                                                _) =>
                                                            sales.tool,
                                                    yValueMapper:
                                                        (ActivityData sales,
                                                                _) =>
                                                            sales.time,
                                                    dataLabelSettings:
                                                        DataLabelSettings(
                                                            isVisible: true),
                                                    yAxisName: "Secs",
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Text(
                                "Today's Breakdown",
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Container(
                                height: size.height * 0.21,
                                child: ListView.separated(
                                  separatorBuilder:
                                      (BuildContext context, int index) =>
                                          Divider(
                                    color: Colors.white,
                                  ),
                                  itemCount: activity.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5,
                                        horizontal: 3,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(activity.keys.toList()[index]),
                                          Text(
                                              "${activity.values.toList()[index].toString()} Secs"),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
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
            ],
          ),
        ),
      ),
    );
  }
}

class ActivityData {
  ActivityData(this.tool, this.time);
  final String tool;
  final double time;
}
