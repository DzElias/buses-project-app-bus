import 'package:bustracking/bloc/buses/buses_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import 'package:socket_io_client/socket_io_client.dart' as iO;

enum ServerStatus { online, offline, connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  late iO.Socket _socket;

  ServerStatus get serverStatus => _serverStatus;

  iO.Socket get socket => _socket;
  Function get emit => _socket.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = iO.io('https://pruebas-socket.herokuapp.com/', {
      'transports': ['websocket'],
      'autoConnect': false
    });

    _socket.on('connect', (_) {
      if (kDebugMode) {
        print('cliente conectado');
      }
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      if (kDebugMode) {
        print('cliente desconectado');
      }
      _serverStatus = ServerStatus.offline;

      notifyListeners();
    });
  }
}
