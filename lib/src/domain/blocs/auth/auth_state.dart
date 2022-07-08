part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  
  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class UserIsAuthenticatedState extends AuthState {
  const UserIsAuthenticatedState({required this.busId}); 

  final String busId;

}

class UserIsNotAuthenticatedState extends AuthState {}
