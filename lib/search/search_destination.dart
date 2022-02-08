

import 'package:bustracking/commons/models/search_destination_result.dart';
import 'package:bustracking/commons/models/search_response.dart';
import 'package:bustracking/services/traffic_service.dart';
import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class SearchDestination extends SearchDelegate<SearchDestinationResult>{

  @override
  final String searchFieldLabel;
  final TrafficService _trafficService;
  final LatLng proximity;

  SearchDestination(this.proximity): 
  searchFieldLabel = 'Elige el lugar de destino',
  this._trafficService = TrafficService();

  @override
  
  TextStyle? get searchFieldStyle => TextStyle(color: Colors.black45, fontSize: 16);
  

  @override
  List<Widget>? buildActions(BuildContext context) {

   

    return [IconButton(
      onPressed: () => query = '', 
      icon: const Icon(Icons.clear),
     
    )];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    SearchDestinationResult searchResult = SearchDestinationResult(cancel: true, manual: false);
    return IconButton(
      onPressed: () => close(context, searchResult), 
      icon: const Icon(Icons.arrow_back)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
   
    
   return _buildResultsSuggestions();
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    if(this.query.length == 0){
      return ListView(children: [
      ListTile(
        leading: const Icon(Icons.place),
        title: const Text('Ubicar manualmente en el mapa'),
        onTap: (){
          close(context, SearchDestinationResult(cancel: false, manual: true));
        },

      )
    ],);
    }

    return _buildResultsSuggestions();
    
    
  }
  
  Widget _buildResultsSuggestions(){

    if(this.query ==0){
      return Container();
    }
    final searchResult = SearchDestinationResult(cancel: true, manual: false);

    return FutureBuilder(
      
      future: this._trafficService.getQueryResults(this.query.trim(), this.proximity),
      builder: (BuildContext context, AsyncSnapshot<SearchResponse> snapshot) {  

        if(!snapshot.hasData){
          return Center(child: CircularProgressIndicator(),);
        }
        
        final places = snapshot.data!.features;
        print('places');
        print(places);
        if(places.length == 0){
          return ListTile(
            title: Text('Direccion no encontrada'),
          );
        }
        
        
        return ListView.builder(

          itemCount: places.length,
          itemBuilder: (BuildContext context, int index) {
            final place = places[index];
            return ListTile(
              leading: Icon(Icons.place) ,
              title: Text(place.textEs),
              subtitle: Text(place.placeNameEs),
              onTap: (){
                print(place);
              },


            );
          },
        );


    },);

  }


}