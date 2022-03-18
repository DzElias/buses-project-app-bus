import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/commons/models/search_destination_result.dart';
import 'package:bustracking/search/search_destination.dart';
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
            top: 90,
          ),
          child: ElevatedButton(
            onPressed: () async {
              final locationBloc =
                  Provider.of<MyLocationBloc>(context, listen: false);
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
    // print('cancel: ${result!.cancel}');
    // print('manual: ${result!.manual}');
    if (result!.cancel) return;
    if (result.manual) {
      final searchBloc = Provider.of<SearchBloc>(context, listen: false);
      searchBloc.add(OnActivateManualMarkerEvent());
    }
  }
}
