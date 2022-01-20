import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:flutter/material.dart';


class AddDestinationPage extends StatelessWidget {
  const AddDestinationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        centerTitle: true,
        title:  Text('Agregar Destino',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontFamily: 'Betm-Medium',
                fontWeight: FontWeight.bold
                )),
        
        ),
      
      body: SafeArea(
          child: Container(
        alignment: Alignment.center,
        child: Column(
          children: [
            Card(
              elevation: 1,
              child: Container(
                margin: const EdgeInsets.all(10),
                width: 370,
                child: Column(
                  children: [
                    Row(
                      children: const [
                        Icon(
                          Icons.radio_button_on,
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text('Tu ubicacion ',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Betm-Medium',
                            )),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Icon(
                          Icons.more_vert,
                          color: Colors.black54,
                        ),
                        //TODO Coloca divider
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_pin,
                          color: Colors.blueAccent,
                        ),
                        SizedBox(width: 10),
                        Text('Elige el lugar de destino ',
                            style: TextStyle(
                              color: Colors.black54,
                              fontFamily: 'Betm-Medium',
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 370,
              child: Container(
                margin: const EdgeInsets.only(
                  top: 10,
                  left: 10,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Busquedas Recientes',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.black87,
                          fontFamily: 'Betm-Medium'),
                    ),
                    GestureDetector(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.location_pin,
                            color: Colors.blueAccent,
                            size: 18,
                          ),
                          Text(
                            'Ubicar en el mapa',
                            style: TextStyle(
                                color: Colors.blue[600],
                                fontSize: 13,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    )
                  ],
                ),
              ),
            ),
            Container(
              width: 370,
              margin: const EdgeInsets.only(top: 25),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric( vertical: 10),
                    child: Row(children: const [
                      Icon(Icons.history),
                      SizedBox(width: 10,),
                      Text('Garden S.A. CDE, Av. San Blas'),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric( vertical: 10),
                    child: Row(children: const [
                      Icon(Icons.history),
                      SizedBox(width: 10,),
                      Text('Plaza City, Ruta 7'),
                    ]),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric( vertical: 10),
                    child: Row(children: const [
                      Icon(Icons.history),
                      SizedBox(width: 10,),
                      Text('Fortis, Av. Monseñor Rodriguez')
                    ]),
                  )
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}
