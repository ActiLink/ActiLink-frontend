import 'package:actilink/auth/logic/auth_cubit.dart';
import 'package:actilink/auth/logic/auth_state.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

class ControllableAuthCubit extends Cubit<AuthState> implements AuthCubit {
  ControllableAuthCubit() : super(const AuthInitial());

  @override
  Future<void> checkAuthStatus() async {
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    await Future<void>.delayed(const Duration(seconds: 1));
    if (email == 'correct@example.com') {
      final user = User(id: 'fake-user-1', name: 'User', email: email);
      emit(AuthAuthenticated(user: user));
    } else {
      emit(const AuthFailure(error: 'Invalid credentials'));
    }
  }

  @override
  Future<void> loginBusinessClient({
    required String email,
    required String password,
  }) async {
    if (email == 'business@example.com') {
      final client = BusinessClient(
        id: 'business-client-id',
        name: 'Business Client',
        email: email,
        taxId: 'PL123',
      );
      emit(AuthAuthenticated(user: client));
    } else {
      emit(const AuthFailure(error: 'Invalid credentials'));
    }
  }

  @override
  Future<void> registerUserAndLogin({
    required String name,
    required String email,
    required String password,
  }) async {
    final user = User(id: 'user-id', name: name, email: email);
    emit(AuthAuthenticated(user: user));
  }

  @override
  Future<void> registerBusinessClientAndLogin({
    required String name,
    required String email,
    required String password,
    required String taxId,
  }) async {
    final client = BusinessClient(
      id: 'business-client-id',
      name: name,
      email: email,
      taxId: taxId,
    );
    emit(AuthAuthenticated(user: client));
  }

  @override
  Future<void> logout(BuildContext context) async {
    emit(const AuthUnauthenticated());
  }

  @override
  Future<void> updateUserProfile(BaseUser updatedUser) async {
    if (state is AuthAuthenticated) {
      emit(AuthAuthenticated(user: updatedUser));
    }
  }

  @override
  AuthState? previousState;

  @override
  bool get isBusinessClient {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user is BusinessClient;
    }
    return false;
  }

  @override
  bool get isLoggedIn => state is AuthAuthenticated;

  @override
  void resetAuthStateAfterFailure({AuthState? setState}) {
    if (setState != null) {
      emit(setState);
    } else if (previousState != null) {
      emit(previousState!);
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  @override
  BaseUser? get user {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user;
    }
    return null;
  }
}
