// To parse this JSON data, do
//
//     final Stop = StopFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';
import 'package:latlong2/latlong.dart';

class Stop {
    Stop({
        required this.id,
        required this.titulo,
        required this.latitud,
        required this.longitud,
        required this.esperas,
    });

    String id;
    String titulo;
    double latitud;
    double longitud;
    int esperas;

    factory Stop.fromRawJson(String str) => Stop.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory Stop.fromJson(Map<String, dynamic> json) => Stop(
        id: json["_id"],
        titulo: json["titulo"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        esperas: json["esperas"].toInt(),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "titulo": titulo,
        "latitud": latitud,
        "longitud": longitud,
        "esperas": esperas,
    };
}
