import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/bloc/my_location/my_location_bloc.dart';
import 'package:user_app/bloc/search/search_bloc.dart';
import 'package:user_app/bloc/stops/stops_bloc.dart';
import 'package:user_app/commons/models/bus.dart';
import 'package:user_app/commons/models/stop.dart';
import 'package:user_app/commons/models/search_destination_result.dart';
import 'package:user_app/pages/options-page/view/options_page.dart';
import 'package:user_app/search/search_destination.dart';
import 'package:user_app/utils/get_options.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:latlong2/latlong.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: const EdgeInsets.only(
            top: 100,
          ),
          child: ElevatedButton(
            onPressed: () async {
              final locationBloc = Provider.of<MyLocationBloc>(context, listen: false);
              final proximity = locationBloc.state.location;
              final searchResult = await showSearch(
                  context: context,
                  delegate: SearchDestinationDelegate(proximity!));
              searchReturn(context, searchResult);
            },
            child: SizedBox(
              width: 300,
              height: 50,
              child: Row(children: const [
                Icon(
                  Icons.location_pin,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Toca para agregar destino',
                  style: TextStyle(
                    color: Colors.black45,
                  ),
                ),
              ]),
            ),
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  void searchReturn(BuildContext context, SearchDestinationResult? result) {
    if (result!.cancel) return;

    if (result.manual) {
      final searchBloc = Provider.of<SearchBloc>(context, listen: false);
      searchBloc.add(OnActivateManualMarkerEvent());
    }
    else
    {
      final locationBloc = Provider.of<MyLocationBloc>(context, listen: false);
      LatLng? userLocation = locationBloc.state.location;

      final stopsBloc =  Provider.of<StopsBloc>(context, listen: false);
      List<Stop> stops = stopsBloc.state.stops;

      final busesBloc =  Provider.of<BusesBloc>(context, listen: false);
      List<Bus> buses = busesBloc.state.buses;

      DestinationService destinationService = DestinationService(buses: buses, stops: stops, userLocation: userLocation!, destination: result.position!);

      List<Option> options = destinationService.getOptions();
      
      if(options.isNotEmpty)
      {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OptionsPage(options: options, destino: result.position!,)
        ),
  );
      }
      else
      {
        Fluttertoast.showToast(msg: "No encontramos opciones para ese destino :(" );
      }
    }

    



  }
}
