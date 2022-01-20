import 'package:flutter/material.dart';

class Custom_button extends StatelessWidget {
  final String text;
  final void Function() onPressed;
  final Color btnColor;
  final Color textColor;

  const Custom_button(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.btnColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 50,
        child: Center(
          child: Text(
            this.text,
            style: TextStyle(fontSize: 18, color: this.textColor),
          ),
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: this.btnColor,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
      ),
    );
  }
}
