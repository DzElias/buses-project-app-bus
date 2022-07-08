import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  final Color btnColor;
  final Color textColor;

  const CustomButton(
      {Key? key,
      required this.text,
      required this.onPressed,
      required this.btnColor,
      required this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal:100),
      child: ElevatedButton(
        onPressed: onPressed,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: Center(
            child: Text(
              text,
              style: TextStyle(fontSize: 18, color: textColor),
            ),
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
      ),
    );
  }
}
