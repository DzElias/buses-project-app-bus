

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showAlert( BuildContext context, String titulo, String subtitulo)async {
  bool value = false;
  if(Platform.isAndroid){
    
    await showDialog(
      context: context, 
      builder: ( _ ) => StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
        titleTextStyle: const TextStyle(fontSize: 18, color: Colors.black87),
        title: Text( titulo ),
        actions: [
          MaterialButton(
            elevation: 5,
            textColor: Colors.deepPurpleAccent.shade400,
            onPressed: () {
              Navigator.pop(context);
              setState((){
                value = true;
              });
            },
            child: const Text('Confirmar')
          ),

          MaterialButton(
            elevation: 5,
            textColor: Colors.deepPurpleAccent.shade400,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('No')
          )
        ], 
      );
        },
      ),
    );

    return value;
  } 

  showCupertinoDialog(
    context: context, 
    builder: ( _ ) => CupertinoAlertDialog(
    
      title: Text( titulo , style: const TextStyle(fontSize: 18, color: Colors.black87),),
      actions: [
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            value = true;
            Navigator.pop(context);
          },
          child: const Text('Confirmar'),
        ),
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('No'),
        )
      ],
    )
  );
  return value;
  

}