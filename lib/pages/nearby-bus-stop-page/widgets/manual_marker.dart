import 'package:animate_do/animate_do.dart';
import 'package:bustracking/bloc/search/search_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                    final searchBloc =
                        Provider.of<SearchBloc>(context, listen: false);
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
            onPressed: () {},
            child: Text(
              'Confirmar destino',
              style: TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        )
      ],
    );
  }
}
