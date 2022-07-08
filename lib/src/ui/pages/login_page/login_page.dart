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
  bool sw = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [

            CustomInput(
              icon: Icons.directions_bus, 
              placeHolder: 'ID del bus', 
              textController: textController,
              isPassword: true,
            ),

            CustomButton(
              text: 'INGRESAR', 
              onPressed: sw ? null :() {
                setState(() {
                  sw = true;
                });
                onSubmit(textController.text.trim());
              },
              btnColor: Colors.blue, 
              textColor: Colors.white,

            )
          ],
        ),
      )
    );
  }

  onSubmit(String text){
    if(text != null){
      Bus? bus = getBusById(text);
      if(bus != null){
       saveBusId(bus);
      }
    }else{
      Fluttertoast.showToast(
        msg: 'El ID ingresado es invalido',
        textColor: Colors.white,
        backgroundColor: const Color(0xff606060)
      );
      setState(() {
        sw = false;
      });

      textController.clear();
                        
    }
    
  }

  Bus? getBusById(String busId){
    final busBlocState = Provider.of<BusBloc>(context, listen: false).state;
    if(busBlocState is BusesLoadedState){
      List<Bus> buses = busBlocState.buses;
      int i = buses.indexWhere((element) => element.id == busId);
      if(i>=0){
        return buses[i];
      }
    }

    return null;
  }

  saveBusId(Bus bus) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: "busId", value: bus.id);

    Future.delayed(Duration.zero).then((value) => Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => NavigationPage(bus: bus,))
    ));
  }
}

