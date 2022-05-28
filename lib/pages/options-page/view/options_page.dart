import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/pages/options-page/widgets/option_widget.dart';
import 'package:bustracking/utils/get_options.dart';
import 'package:flutter/material.dart';

import 'package:latlong2/latlong.dart';


class OptionsPage extends StatelessWidget {
  final List<Option> options;
  final LatLng destino;
  const OptionsPage({ Key? key, required this.options, required this.destino }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(backgroundColor: Colors.white, title: Text("Opciones Disponibles", style: TextStyle(color: Colors.black87), ), centerTitle: true,),

      body: Stack(
        children: [
          ListView.separated(
            itemCount: options.length,

            itemBuilder: (context, i) {
              Option option = options[i];
              return OptionWidget(option: option, destino: destino,);
            },
            separatorBuilder: (context, i) => const Divider(height: 50,),
          )
        ]
      ),
    );
  }
}

