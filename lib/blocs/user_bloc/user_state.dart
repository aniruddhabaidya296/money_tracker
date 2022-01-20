part of 'user_bloc.dart';

abstract class UserState extends Equatable {
  @override
  List<Object> get props => [];
}

class UserEventInitial extends UserState {}

class FetchUserSuccess extends UserState {
  final List<User> users;

  FetchUserSuccess({this.users});

  @override
  List<Object> get props => [users];
}

class UserLoading extends UserState {}

class FetchUserFailed extends UserState {}
