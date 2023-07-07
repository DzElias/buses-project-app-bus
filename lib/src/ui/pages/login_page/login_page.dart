import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:me_voy_chofer/src/domain/blocs/bus/bus_bloc.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';
import 'package:me_voy_chofer/src/ui/pages/login_page/widgets/custom_button.dart';
import 'package:me_voy_chofer/src/ui/pages/login_page/widgets/custom_input.dart';
import 'package:me_voy_chofer/src/ui/pages/navigation-page/navigation_page.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController textController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool sw = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomInput(
                  icon: Icons.badge,
                  placeHolder: 'Numero de cedula',
                  textController: textController,
                  isPassword: false,
                ),
                CustomInput(
                  icon: Icons.lock,
                  placeHolder: 'Contraseña',
                  textController: passController,
                  isPassword: true,
                ),
                CustomButton(
                  text: 'INGRESAR',
                  onPressed: sw
                      ? null
                      : () {
                          setState(() {
                            sw = true;
                          });
                          onSubmit(textController.text.trim(),
                              passController.text.trim());
                        },
                  btnColor: Colors.deepPurpleAccent.shade400,
                  textColor: Colors.white,
                )
              ],
            ),
          ),
        ));
  }

  onSubmit(String ci, String pass) async {
    if (ci.isEmpty || pass.isEmpty) {
      setState(() {
        sw = false;
      });

      textController.clear();
      return Fluttertoast.showToast(
          msg: 'Credenciales invalidas',
          textColor: Colors.white,
          backgroundColor: const Color(0xff606060));
    }

    Dio dio = Dio();
    try {
      dio.options.headers['content-Type'] = 'application/json';
      print(pass);
      Response response = await dio
          .post("https://api-buses.onrender.com/api/auth/signin", data: {
        "ci": ci,
        "password": pass,
      });

      if (response.data['busId'] != null) {
        saveToken(response.data['busId'], response.data['token']);
      }
    } catch (e) {
      setState(() {
        sw = false;
      });

      textController.clear();
      passController.clear();
      print(e);
      Fluttertoast.showToast(
          msg: 'Credenciales invalidas',
          textColor: Colors.white,
          backgroundColor: const Color(0xff606060));
    }
  }

  saveToken(String busId, String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "token", value: token);

    Bus? bus = getBusById(busId);
    if (bus != null) {
      Future.delayed(Duration.zero).then((value) => Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => NavigationPage(
                    bus: bus,
                  ))));
    } else {
      setState(() {
        sw = false;
      });

      textController.clear();
      passController.clear();
      Fluttertoast.showToast(
          msg: 'Ocurrio un error al iniciar sesion',
          textColor: Colors.white,
          backgroundColor: const Color(0xff606060));
    }
  }

  Bus? getBusById(String busId) {
    final busBlocState = Provider.of<BusBloc>(context, listen: false).state;
    if (busBlocState is BusesLoadedState) {
      List<Bus> buses = busBlocState.buses;
      int i = buses.indexWhere((element) => element.id == busId);
      if (i >= 0) {
        return buses[i];
      }
    }

    return null;
  }
}
