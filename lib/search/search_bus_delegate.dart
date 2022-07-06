import 'package:user_app/bloc/buses/buses_bloc.dart';
import 'package:user_app/commons/models/bus.dart';

import 'package:flutter/Material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BusSearch extends SearchDelegate<String> {
  List<Bus> _filter = [];
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              query = '';
            })
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back_ios),
      onPressed: () => close(context, ""));

  @override
  Widget buildResults(BuildContext context) {
    return ListView.separated(
        itemBuilder: (context, i) {
          final bus = _filter[i];
          return ListTile(
            title: Text(bus.company),
            leading: Icon(
              Icons.directions_bus_rounded,
              color: Colors.black,
            ),
            onTap: () {
              close(context, bus.id);
            },
          );
        },
        separatorBuilder: (context, i) => const Divider(),
        itemCount: _filter.length);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return BlocBuilder<BusesBloc, BusesState>(builder: (context, state) {
      final buses = state.buses;
      _filter = buses.where((bus) {
        return bus.company.toLowerCase().contains(query.trim().toLowerCase());
      }).toList();
      return ListView.separated(
        itemCount: _filter.length,
        itemBuilder: (_, index) {
          return ListTile(
            title: Text(_filter[index].company),
            onTap: () {
              close(context, _filter[index].id);
            },
          );
        },
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      );
    });
  }
}
