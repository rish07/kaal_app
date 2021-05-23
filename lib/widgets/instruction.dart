import 'package:flutter/material.dart';

class Instructions extends StatelessWidget {
  const Instructions({
    Key key,
    @required this.size,
    this.text,
    this.imagePath,
  }) : super(key: key);

  final Size size;
  final String text;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1F2228),
      body: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: size.height * 0.05,
          ),
          Image.asset(imagePath)
        ],
      ),
    );
  }
}
