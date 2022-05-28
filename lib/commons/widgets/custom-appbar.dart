import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool centerTitle;
  final Color? backgroundColor;
  const CustomAppBar({Key? key, required this.title, this.centerTitle = false, required this.backgroundColor})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  //TODO Hacer customizable para todas las pantallas

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title,
      centerTitle: centerTitle,
      elevation: (backgroundColor == Colors.transparent)? 0.0 : 1.0,
      backgroundColor: this.backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }
}
