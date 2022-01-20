// To parse this JSON data, do
//
//     final bus = busFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Bus busFromJson(String str) => Bus.fromJson(json.decode(str));

String busToJson(Bus data) => json.encode(data.toJson());

class Bus {
    Bus({
        required this.id,
        required this.titulo,
        required this.linea,
        required this.paradas,
        required this.primeraParada,
        required this.ultimaParada,
        required this.proximaParada,
        required this.latitud,
        required this.longitud,
    });
    String id;
    String titulo;
    String linea;
    List<dynamic> paradas;
    String primeraParada;
    String ultimaParada;
    String proximaParada;
    double latitud;
    double longitud;

    factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        id: json["_id"],
        titulo: json["titulo"],
        linea: json["linea"],
        paradas: List<dynamic>.from(json["Paradas"].map((x) => x)),
        primeraParada: json["PrimeraParada"],
        ultimaParada: json["UltimaParada"],
        proximaParada: json["ProximaParada"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "titulo": titulo,
        "linea": linea,
        "Paradas": List<dynamic>.from(paradas.map((x) => x)),
        "PrimeraParada": primeraParada,
        "UltimaParada": ultimaParada,
        "ProximaParada": proximaParada,
        "latitud": latitud,
        "longitud": longitud,
    };
}
