import 'package:bloc/bloc.dart';
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

    String? busId = await storage.read(key: "busId");
    return busId;
    
  }
}
