import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            child: Center(
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          top: 30,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 30,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        image: DecorationImage(
                            image: AssetImage("assets/selfie-woman.jpg"),
                            fit: BoxFit.fill)),
                  ),
                  Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: Column(
                        children: [
                          Text(
                            "Maria",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Gonzalez",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )),
                  ListTile(
                    leading:
                        Icon(Icons.location_city, color: Colors.red, size: 30),
                    title: Text(
                      "Paradas cercanas",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(
                          context, 'nearby-bus-stop-page');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.directions_bus,
                        color: Colors.green, size: 30),
                    title: Text(
                      "Buscar autobuses",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'search-bus');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications_active,
                        color: Colors.blueAccent, size: 30),
                    title: Text(
                      "Recordatorios diarios",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Betm-Medium'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, 'daily-reminders-page');
                    },
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: ListTile(
                leading:
                    Icon(Icons.logout_outlined, color: Colors.orange, size: 30),
                title: Text(
                  "Cerrar sesion",
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                onTap: () {
                  Navigator.pushReplacementNamed(context, 'login');
                },
              ),
            ),
          ),
        ],
      ),
    ));
  }
}