import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:me_voy_chofer/src/domain/blocs/location_permissions/location_permission_bloc.dart';

import 'package:provider/provider.dart';

class RequestPermissionButton extends StatelessWidget {
  const RequestPermissionButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        primary: Colors.blueAccent,
        
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 20),
        child: Text("Establecer automaticamente", style: TextStyle(
          color: Colors.white, 
          fontSize: 18
        ),),
      ),
      onPressed: (){
        Provider.of<LocationPermissionBloc>(context, listen: false).add(TapPermissionsButtonEvent());
      }, 
    );
  }
}