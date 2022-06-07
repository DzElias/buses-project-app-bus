import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/services/socket_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget title;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool goBack;
  const CustomAppBar(
      {Key? key,
      required this.title,
      this.centerTitle = false,
      required this.backgroundColor,
      this.goBack = true})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(60.0);

  //TODO Hacer customizable para todas las pantallas

  @override
  Widget build(BuildContext context) {
    bool isConnected = true;
    bool sw = false;
    var serverStatus = Provider.of<SocketService>(context).serverStatus;


    if(serverStatus == ServerStatus.offline){ 
      // Future.delayed(Duration(seconds: 2));
      isConnected = false;
      sw = true;
    };
    
    if(serverStatus == ServerStatus.online){ 
      isConnected = true; 
      if(sw){
        final busesBloc = Provider.of<BusesBloc>(context, listen: false);
        busesBloc.getBuses();
        final stopsBloc = Provider.of<StopsBloc>(context, listen: false);
        stopsBloc.getStops();
      }
    };
    return AppBar(
      title:isConnected? title : Text("No tienes conexion a internet"),
      // title: title,
      centerTitle: centerTitle,
      elevation: (backgroundColor == Colors.transparent) ? 0.0 : 1.0,
      backgroundColor: isConnected ? this.backgroundColor : Colors.red,
      // backgroundColor: this.backgroundColor,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.dark,
      ),
      automaticallyImplyLeading:(isConnected && goBack),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    );
  }
}
