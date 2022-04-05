
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {

  final String pageName;

  const Logo({Key? key, required this.pageName}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.only(top: 50),
        width: 170,
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Image(image: AssetImage("assets/bus.png")),
            // ignore: prefer_const_constructors
            SizedBox(
              height: 20,
            ),
            Text(
              pageName,
              style: const TextStyle(fontSize: 25),
            )
          ],
        ),
      ),
    );
  }
}