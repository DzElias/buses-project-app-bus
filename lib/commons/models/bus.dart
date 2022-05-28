import 'dart:convert';

Bus busFromJson(String str) => Bus.fromJson(json.decode(str));

String busToJson(Bus data) => json.encode(data.toJson());

class Bus {
  Bus({
    required this.id,
    required this.linea,
    required this.paradas,
    required this.primeraParada,
    required this.ultimaParada,
    required this.proximaParada,
    required this.latitud,
    required this.longitud,
    required this.titulo,
    required this.activo,
    required this.ruta,
  });

  String id;
  String linea;
  List<String> paradas;
  String primeraParada;
  String ultimaParada;
  String proximaParada;
  double latitud;
  double longitud;

  String titulo;
  bool activo;
  String ruta;

  factory Bus.fromJson(Map<String, dynamic> json) => Bus(
        id: json["_id"],
        linea: json["linea"],
        paradas: List<String>.from(json["Paradas"].map((x) => x)),
        primeraParada: json["PrimeraParada"],
        ultimaParada: json["UltimaParada"],
        proximaParada: json["ProximaParada"],
        latitud: json["latitud"].toDouble(),
        longitud: json["longitud"].toDouble(),
        titulo: json["titulo"],
        activo: json["activo"],
        ruta: json["ruta"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "linea": linea.toString(),
        "Paradas": List<dynamic>.from(paradas.map((x) => x)),
        "PrimeraParada": primeraParada,
        "UltimaParada": ultimaParada,
        "ProximaParada": proximaParada,
        "latitud": latitud,
        "longitud": longitud,
        "titulo": titulo,
        "activo": activo,
        "ruta": ruta,
      };
}
