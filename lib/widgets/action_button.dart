import 'package:flutter/material.dart';
import 'package:kaal_bot/constants.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    Key key,
    @required this.size,
    bool isCopied,
    this.onTap,
    this.title,
  }) : super(key: key);

  final Size size;
  final Function onTap;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.27),
      child: MaterialButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
        color: violetColor,
        onPressed: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
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
    );
  }
}
