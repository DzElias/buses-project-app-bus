import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:me_voy_chofer/src/domain/entities/bus.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage storage;
  AuthBloc(this.storage) : super(AuthInitial()) {
    on<CheckIfUserIsAuthenticatedEvent>((event, emit) async {
      final String? busId = await checkIfUserIsAuthenticated();

      if(busId != null){
        emit(UserIsAuthenticatedState(busId: busId));
      }else{
        emit(UserIsNotAuthenticatedState());
      }
    });
  }
  
  Future<String?> checkIfUserIsAuthenticated() async {

    String? token = await storage.read(key: "token");
    if(token == null)return null;
    try {
      Dio dio = Dio();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["x-access-token"] = token;
      Response response = await dio.post("https://api-buses.onrender.com/api/auth/verifyToken", data: {});  
      if(response.data['busId'] != null){
        return response.data['busId'];
      }
      
    } catch (e) {
      await storage.delete(key: "token");
      return null;
    }

    return null;;
    
  }
}
