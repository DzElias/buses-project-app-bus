import 'package:animate_do/animate_do.dart';
import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/bloc/map/map_bloc.dart';
import 'package:user_app/bloc/my_location/my_location_bloc.dart';
import 'package:user_app/bloc/search/search_bloc.dart';
import 'package:user_app/bloc/stops/stops_bloc.dart';
import 'package:user_app/pages/options-page/view/options_page.dart';
import 'package:user_app/utils/get_options.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'package:latlong2/latlong.dart';

class ManualMarker extends StatelessWidget {
  const ManualMarker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Positioned(
            top: 70,
            left: 20,
            child: CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.white,
              child: IconButton(
                  onPressed: () {
                    final searchBloc =Provider.of<SearchBloc>(context, listen: false);
                    searchBloc.add(OnDeactivateManualMarkerEvent());
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.green,
                  )),
            )),
        Center(
          child: Transform.translate(
              offset: Offset(0, -20),
              child: BounceInDown(
                from: 200,
                child: Icon(
                  Icons.place,
                  size: 50,
                  color: Colors.green,
                ),
              )),
        ),
        Positioned(
          bottom: 70,
          left: 20,
          right: 20,
          child: MaterialButton(
            shape: StadiumBorder(),
            minWidth: width,
            padding: EdgeInsets.symmetric(vertical: 16),
            color: Colors.green,
            elevation: 0,
            onPressed: () 
            {
              final mapBloc = Provider.of<MapBloc>(context, listen: false);
              LatLng center = mapBloc.mapController.center;

              final myLocationBloc = Provider.of<MyLocationBloc>(context, listen: false);
              LatLng userLocation = myLocationBloc.state.location!;

              final stops = Provider.of<StopsBloc>(context, listen: false).state.stops;
              final buses = Provider.of<BusesBloc>(context, listen: false).state.buses;


              var destinationService = DestinationService(buses: buses , stops: stops, userLocation: userLocation, destination: center);
              var options = destinationService.getOptions();

              final searchBloc =Provider.of<SearchBloc>(context, listen: false);
              searchBloc.add(OnDeactivateManualMarkerEvent());

              if(options.isNotEmpty)
              {
                Navigator.push( context,MaterialPageRoute(builder: (context) => OptionsPage(options: options, destino: center, )));
      
              }
              else
              {
                 Fluttertoast.showToast(msg: "No encontramos opciones para ese destino :(" );
              }
            },
            child: Text('Confirmar destino', style: TextStyle(fontSize: 18, color: Colors.white),),
          ),
        )
      ],
    );
  }
}
