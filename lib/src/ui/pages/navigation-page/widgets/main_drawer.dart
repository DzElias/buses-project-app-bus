// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// class MainDrawer extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Drawer(
//         child: Container(
//       color: Colors.white,
//       child: Column(
//         mainAxisSize: MainAxisSize.max,
//         children: [
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(20),
//             child: Center(
//               child: Column(
//                 children: [
//                   Align(
//                     alignment: Alignment.topLeft,
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.pop(context);
//                       },
//                       child: Container(
//                         margin: const EdgeInsets.only(
//                           top: 30,
//                         ),
//                         child: const Icon(
//                           Icons.close,
//                           size: 30,
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Container(
//                   //   width: 100,
//                   //   height: 100,
//                   //   decoration: const BoxDecoration(
//                   //       shape: BoxShape.rectangle,
//                   //       image: DecorationImage(
//                   //           image: AssetImage("assets/images/bus.png"),
//                   //           fit: BoxFit.contain)),
//                   // ),
//                   Container(
//                       margin: const EdgeInsets.only(top: 15, bottom: 15),
//                       child: Column(
//                         children: [
//                           // const Text(
//                           //   "Alla voy",
//                           //   style: TextStyle(
//                           //     fontSize: 20,
//                           //   ),
//                           //   textAlign: TextAlign.center,
//                           // ),
//                           // const Text(
//                           //   "",
//                           //   style: TextStyle(
//                           //     fontSize: 20,
//                           //   ),
//                           //   textAlign: TextAlign.center,
//                           // ),
//                         ],
//                       )),
//                   ListTile(
//                     leading: const Icon(Icons.logout, color: Colors.red, size: 30),
//                     title: const Text("Cerrar sesion", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
//                     onTap: () async {
//                         const FlutterSecureStorage storage = FlutterSecureStorage();
//                         await storage.delete(key: "token");
//                         Navigator.pushReplacementNamed(context, 'login-page');
//                     },
//                   ),
//                 ],
//               ),
//             ),
//           ),
          
//         ],
//       ),
//     ));
//   }
// }