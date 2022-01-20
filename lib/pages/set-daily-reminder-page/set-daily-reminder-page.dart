// ignore_for_file: file_names

import 'package:bustracking/commons/widgets/custom-appbar.dart';
import 'package:bustracking/widgets/multiSelect.dart';

import 'package:flutter/material.dart';

class SetDailyReminderPage extends StatefulWidget {
  const SetDailyReminderPage({Key? key}) : super(key: key);

  @override
  State<SetDailyReminderPage> createState() => _SetDailyReminderPageState();
}

class _SetDailyReminderPageState extends State<SetDailyReminderPage> {
  bool isSelected = false;
  String timeselectedValue = '1';
  List<DropdownMenuItem<String>> get timedropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("5 min"), value: "1"),
      const DropdownMenuItem(child: Text("10 min"), value: "2"),
      const DropdownMenuItem(child: Text("15 min"), value: "3"),
      const DropdownMenuItem(child: Text("30 min"), value: "4"),
    ];
    return menuItems;
  }

  String placesselectedValue = '1';
  List<DropdownMenuItem<String>> get placesdropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(child: Text("Ciudad Nueva"), value: "1"),
      const DropdownMenuItem(child: Text("San Jose"), value: "2"),
      const DropdownMenuItem(child: Text("23 de Octubre"), value: "3"),
      const DropdownMenuItem(child: Text("Santa Ana"), value: "4"),
    ];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Configurar recordatorio ',
            style: TextStyle(
                fontSize: 17,
                color: Colors.black87,
                fontFamily: 'Betm-Medium',
                fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              searchBusBox(),
              setReminderFirstColumn(),
              setReminderScondColumn(),
              Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.blueAccent,
                  shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(0.0),
                  ),
                ),
                onPressed: () {},
                child: Container(
                  padding: EdgeInsets.all(25),
                  child: Center(
                    child: Text(
                      'Guardar',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontFamily: 'Betm-Medium'),
                    ),
                  ),
                ),
              )

              // setReminderScondColumn(),
            ],
          ),
        ],
      ),
    );
  }

  List<String> selectedDaysList = [];
  List<String> daysList = [
    "Domingo",
    "Lunes",
    "Martes",
    "Miercoles",
    "Jueves",
    "Viernes",
    "Sabado"
  ];

  setReminderScondColumn() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Icon(
                Icons.event,
                color: Colors.blueAccent,
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                'Los dias',
                style: TextStyle(
                    fontFamily: 'Betm-Medium',
                    color: Colors.blueAccent,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child:
                MultiSelectChip(daysList, onSelectionChanged: (selectedList) {
              setState(() {
                selectedDaysList = selectedList;
              });
            }),
          ),
        ],
      ),
    );
  }

  setReminderFirstColumn() {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 20,
      ),
      padding: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Row(
              children: const [
                Icon(
                  Icons.notifications_active,
                  color: Colors.blueAccent,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Recuerdame',
                  style: TextStyle(
                      fontFamily: 'Betm-Medium',
                      color: Colors.blueAccent,
                      fontWeight: FontWeight.w600,
                      fontSize: 15),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(
              left: 50,
              right: 50,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                timeDropDownButton(),
                const Text('Antes de '),
                placesDropDownButton(),
              ],
            ),
          )
        ],
      ),
    );
  }

  timeDropDownButton() {
    return DropdownButton(
        value: timeselectedValue,
        onChanged: (String? newValue) {
          setState(() {
            timeselectedValue = newValue!;
          });
        },
        items: timedropdownItems);
  }

  placesDropDownButton() {
    return DropdownButton(
        value: placesselectedValue,
        onChanged: (String? newValue) {
          setState(() {
            placesselectedValue = newValue!;
          });
        },
        items: placesdropdownItems);
  }

  searchBusBox() {
    return Align(
      alignment: Alignment.topCenter,
      child: ElevatedButton(
        onPressed: () {},
        child: SizedBox(
          width: 350,
          height: 60,
          child: Row(children: const [
            Icon(Icons.directions_bus, color: Colors.green),
            SizedBox(
              width: 10,
            ),
            Text('Linea 270 Mburucuya Poty',
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.black87,
                    fontFamily: 'Betm-Medium',
                    fontWeight: FontWeight.bold)),
          ]),
        ),
        style: ElevatedButton.styleFrom(
          primary: Colors.white,
        ),
      ),
    );
  }
}
