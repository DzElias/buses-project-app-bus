import 'package:bustracking/widgets/custom_button.dart';
import 'package:bustracking/widgets/custom_input.dart';
import 'package:bustracking/widgets/labels.dart';
import 'package:bustracking/widgets/logo.dart';
import 'package:bustracking/widgets/terms-and-conditions.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
     return Scaffold(
        backgroundColor: Color(0xffF2F2F2),
        body: SafeArea(
          child:  SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height*0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [Logo(pageName: 'Registro',), _Form(), const Labels(route: 'login', text:'¿Ya tiene una cuenta?', text2:'¡Ingrese ahora!'), TermsandContditions()],
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
  final nameCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
           CustomInput(
            icon: Icons.perm_identity,
            placeHolder: 'Nombre completo',
            textController: nameCtrl,
            
          ),
          CustomInput(
            icon: Icons.mail_outline,
            placeHolder: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeHolder: 'Contraseña nueva',
            textController: passCtrl,
            isPassword: true,
          ),
          
          Custom_button(
            btnColor: Colors.blueAccent,
            textColor: Colors.white,
            text: 'Registrar',
            onPressed: (){
              Navigator.pushReplacementNamed(context, 'login');
              
            }
          )

          //TODO Crea boton
        ],
      ),
    );
  }
}
