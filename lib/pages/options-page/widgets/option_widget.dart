import 'package:bustracking/bloc/stops/stops_bloc.dart';
import 'package:bustracking/commons/models/bus.dart';
import 'package:bustracking/commons/models/stop.dart';
import 'package:bustracking/pages/bus-page/models/bus_page_arguments.dart';
import 'package:bustracking/utils/get_options.dart';
import 'package:flutter/Material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class OptionWidget extends StatelessWidget {
  const OptionWidget({
    Key? key,
    required this.option,
    required this.destino
  }) : super(key: key);

  final Option option;
  final LatLng destino;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.pushReplacementNamed(context, "bus-page", arguments: BusPageArguments(bus: option.bus, stop: option.paradaA, stopsSelected: [option.paradaA.id, option.paradaB.id], waiting: false, destino: destino));
        
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.directions_bus, color: Colors.green, size: 30,),
                SizedBox(width: 10,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Linea ${option.bus.linea} ${option.bus.titulo}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),),
                    Text("Desde ${option.paradaA.titulo.replaceFirst("Parada", "")} hasta ${option.paradaB.titulo.replaceFirst("Parada", "")}", style: TextStyle(fontSize: 13),)
                  ],
                ),
                Spacer(),
                Column(
                  children: [
                    Text("${travelTime(option.paradaA, option.paradaB, option.bus, context) + 5}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Text("min", style:  TextStyle( fontWeight: FontWeight.bold))
                  ],
                )
              ],
    
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(Icons.directions_walk, color: Colors.blueAccent, size: 20,),
                SizedBox(width: 5),
                
    
                Icon(Icons.arrow_forward_ios, size: 20),
                SizedBox(width: 5),
    
                Icon(Icons.directions_bus, color: Colors.green, size: 20),
                SizedBox(width: 5),
                
        
                Icon(Icons.arrow_forward_ios, size: 20),
                SizedBox(width: 5),
    
                Icon(Icons.directions_walk, color: Colors.blueAccent, size: 20),
                SizedBox(width: 15),
                Spacer(),
    
                
                Text("¡Vamos!  ", style: TextStyle(fontSize: 16, color: Colors.blueAccent, fontWeight: FontWeight.w500)),
                Icon(Icons.arrow_forward, size: 20, color: Colors.blueAccent,),
    
          
              ],
            )
          ],
        )
      ),
    );
  }

  int calculateDistance(LatLng point, LatLng myLocation) {
    //TODO: si es menor a mil pasar metros y si es mas pasar a km y redondear
    var _distanceInMeters = Geolocator.distanceBetween(point.latitude,
        point.longitude, myLocation.latitude, myLocation.longitude);

    int distance = _distanceInMeters.round();
    return distance;
  }

  travelTime(Stop paradaA, Stop paradaB, Bus bus, BuildContext context)
  {
    LatLng pointA = LatLng(paradaA.latitud, paradaA.longitud);
    LatLng pointB = LatLng(paradaB.latitud, paradaB.longitud);

    int indexA = bus.paradas.indexWhere((element) => element == paradaA.id);
    int indexB = bus.paradas.indexWhere((element) => element == paradaB.id);

    var stopsBloc = Provider.of<StopsBloc>(context, listen:false);

    int distance = 0;

    if(indexA < indexB){
      for(int i = indexA; i<indexB; i++)
      {
        int indexC = stopsBloc.state.stops.indexWhere((element) => element.id == bus.paradas[i]);
        Stop stopC = stopsBloc.state.stops[indexC];

        int indexD = stopsBloc.state.stops.indexWhere((element) => element.id == bus.paradas[i + 1]);
        Stop stopD = stopsBloc.state.stops[indexD];

        distance = distance + calculateDistance(LatLng(stopC.latitud, stopC.longitud), LatLng(stopD.latitud, stopD.longitud));
      }
     
      distance = distance + calculateDistance(LatLng(bus.latitud, bus.longitud),LatLng(paradaA.latitud, paradaA.longitud));
    }
    


    String time;
    int hours = 0;
    int minutes = (((distance / 1000) * 60) / 12).round();
    while (minutes > 60) {
      hours = hours + 1;
      minutes = minutes - 60;
    }
    if (hours == 0) {
      
      return minutes;
    } 
    else {
      return 54;
    }
  }

}
