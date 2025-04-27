import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});
  final BaseUser user;

  @override
  List<Object?> get props => [user];
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated({this.message});
  final String? message;

  @override
  List<Object?> get props => [message];
}

final class AuthFailure extends AuthState {
  const AuthFailure({required this.error});
  final String error;
  @override
  List<Object?> get props => [error];
}
