import 'package:bustracking/commons/widgets/custom_button.dart';
import 'package:bustracking/commons/widgets/custom_input.dart';
import 'package:bustracking/commons/widgets/labels.dart';
import 'package:bustracking/commons/widgets/logo.dart';
import 'package:bustracking/commons/widgets/terms-and-conditions.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child:  SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height*1,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Logo(pageName: 'Alla voy',), _Form(), Labels(route: 'register', text:'¿No tiene una cuenta?', text2:'¡Crea una ahora!'), TermsandContditions()],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  ___FormState createState() => ___FormState();
}

class ___FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña',
            textController: passCtrl,
            isPassword: true,
            
          ),
          
          Custom_button(
            btnColor: Colors.blueAccent,
            textColor: Colors.white,
            text: 'Ingresar',
            onPressed: (){
              Navigator.pushReplacementNamed(context, 'nearby-bus-stop-page');
            }
          )

          //TODO Crea boton
        ],
      ),
    );
  }
}
