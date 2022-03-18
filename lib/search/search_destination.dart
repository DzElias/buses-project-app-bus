import 'package:bustracking/bloc/my_location/my_location_bloc.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:bustracking/commons/models/search_destination_result.dart';
import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

class SearchDestinationDelegate
    extends SearchDelegate<SearchDestinationResult> {
  SearchDestinationDelegate(LatLng latLng)
      : super(searchFieldLabel: 'Buscar...');

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            query = '';
          })
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () {
        final result = SearchDestinationResult(cancel: true);
        close(context, result);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchBloc = BlocProvider.of<SearchBloc>(context);
    final proximity = BlocProvider.of<MyLocationBloc>(context).state.location;
    searchBloc.getPlacesByQuery(proximity!, query);

    return BlocBuilder<SearchBloc, SearchState>(
      builder: (context, state) {
        final places = state.places;

        return ListView.separated(
          itemCount: places.length,
          itemBuilder: (context, i) {
            final place = places[i];
            return ListTile(
                title: Text(place.text),
                subtitle: Text(place.placeName),
                leading: const Icon(Icons.place_outlined, color: Colors.black),
                onTap: () {
                  final result = SearchDestinationResult(
                      cancel: false,
                      manual: false,
                      position: LatLng(place.center[1], place.center[0]),
                      name: place.text,
                      description: place.placeName);

                  searchBloc.add(AddToHistoryEvent(place));

                  close(context, result);
                });
          },
          separatorBuilder: (context, i) => const Divider(),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final history = BlocProvider.of<SearchBloc>(context).state.history;

    return ListView(
      children: [
        ListTile(
            leading:
                const Icon(Icons.location_on_outlined, color: Colors.black),
            title: const Text('Colocar la ubicación manualmente',
                style: TextStyle(color: Colors.black)),
            onTap: () {
              final result =
                  SearchDestinationResult(cancel: false, manual: true);
              close(context, result);
            }),
        ...history.map((place) => ListTile(
            title: Text(place.text),
            subtitle: Text(place.placeName),
            leading: const Icon(Icons.history, color: Colors.black),
            onTap: () {
              final result = SearchDestinationResult(
                  cancel: false,
                  manual: false,
                  position: LatLng(place.center[1], place.center[0]),
                  name: place.text,
                  description: place.placeName);

              close(context, result);
            }))
      ],
    );
  }
}
