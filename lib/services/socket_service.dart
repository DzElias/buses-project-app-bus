import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}


class SocketService with ChangeNotifier {

  ServerStatus _serverStatus = ServerStatus.Connecting;
  late IO.Socket _socket;

  ServerStatus get serverStatus => this._serverStatus;
  
  IO.Socket get socket => this._socket;
  Function get emit => this._socket.emit;


  SocketService(){
    this._initConfig();
  }

  void _initConfig() {
    
    // Dart client
    this._socket = IO.io('https://pruebas-socket.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': true
    });

    this._socket.on('connect', (_) {
      print('cliente conectado');
      this._serverStatus = ServerStatus.Online;
      notifyListeners();
    });
    

    this._socket.on('disconnect', (_) {
      print('cliente desconectado');
      this._serverStatus = ServerStatus.Offline;
      
      notifyListeners();
    });
    
    

  }

}