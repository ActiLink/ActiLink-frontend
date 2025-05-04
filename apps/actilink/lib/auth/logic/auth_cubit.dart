import 'dart:async';
import 'dart:developer';

import 'package:actilink/auth/logic/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    _userSubscription = _authService.userStream.listen(_onUserChanged);
  }

  final AuthService _authService;
  StreamSubscription<BaseUser?>? _userSubscription;
  bool get isLoggedIn => state is AuthAuthenticated;
  BaseUser? get user => isLoggedIn ? (state as AuthAuthenticated).user : null;
  bool get isBusinessClient => isLoggedIn && user is BusinessClient;

  void _onUserChanged(BaseUser? user) {
    if (isClosed) return;
    final currentState = state;
    if (user != null) {
      if (currentState is AuthAuthenticated && currentState.user == user) {
        return;
      }
      log('AuthCubit: User stream indicates authentication: ${user.runtimeType} ${user.name}');
      emit(AuthAuthenticated(user: user));
    } else {
      if (currentState is AuthUnauthenticated) return;
      if (currentState is! AuthFailure && currentState is! AuthLoading) {
        log('AuthCubit: User stream indicates unauthentication.');
        emit(const AuthUnauthenticated(message: 'Session ended.'));
      }
    }
  }

  Future<void> checkAuthStatus() async {
    if (state is AuthLoading) return;
    log('AuthCubit: Checking auth status...');
    emit(const AuthLoading(message: 'Checking session...'));
    try {
      final user = await _authService.checkInitialAuthStatus();
      if (user == null && !isClosed && state is AuthLoading) {
        emit(
          const AuthUnauthenticated(
            message: 'No valid session found.',
          ),
        );
      } else if (user != null && !isClosed) {
        emit(AuthAuthenticated(user: user));
      }
    } catch (e) {
      log('AuthCubit: Error during initial auth check: $e');
      if (isClosed) return;
      emit(const AuthFailure(error: 'Failed to verify login status.'));
    }
  }

  Future<T?> _handleAuthApiCall<T>({
    required String actionName,
    required String loadingMessage,
    required Future<T> Function() apiCall,
    required String genericErrorMessage,
    void Function(ApiException exception)? handleSpecificErrors,
  }) async {
    if (state is AuthLoading) return null;
    log('AuthCubit: $actionName...');
    emit(AuthLoading(message: loadingMessage));

    try {
      final result = await apiCall();
      return result;
    } on ApiException catch (e) {
      log('AuthCubit: $actionName Error: $e');
      if (isClosed) return null;

      if (handleSpecificErrors != null) {
        handleSpecificErrors(e);
      } else {
        emit(AuthFailure(error: e.message));
      }
    } catch (e) {
      log('AuthCubit: $actionName Generic Error: $e');
      if (isClosed) return null;
      emit(AuthFailure(error: genericErrorMessage));
    }
    return null;
  }

  Future<void> _handleRegistrationProcess({
    required String userType,
    required String email,
    required Future<void> Function() registerFunction,
    required Future<void> Function() loginFunction,
  }) async {
    var registrationSucceeded = false;

    await _handleAuthApiCall<void>(
      actionName: 'Registering $userType $email',
      loadingMessage: 'Creating ${userType.toLowerCase()} account...',
      apiCall: () async {
        await registerFunction();
        registrationSucceeded = true;
      },
      genericErrorMessage: 'An unknown error occurred during sign up.',
      handleSpecificErrors: (e) {
        if (e is ConflictException) {
          emit(AuthFailure(error: "Email '$email' is already registered."));
        } else if (e is BadRequestException) {
          emit(AuthFailure(error: 'Registration failed: ${e.message}'));
        } else {
          emit(AuthFailure(error: e.message));
        }
      },
    );

    if (registrationSucceeded && !isClosed) {
      emit(
        AuthUnauthenticated(
          message: '${userType.toLowerCase()} account created successfully.',
        ),
      );
      log('AuthCubit: $userType registration successful for $email. Logging in...');
      await loginFunction();
    }
  }

  Future<void> _handleLoginProcess({
    required String userType,
    required String email,
    required Future<BaseUser> Function() loginFunction,
  }) async {
    final user = await _handleAuthApiCall<BaseUser>(
      actionName: 'Logging in $email',
      loadingMessage: 'Signing in...',
      apiCall: loginFunction,
      genericErrorMessage: 'An unknown error occurred during login.',
      handleSpecificErrors: (e) {
        if (e is UnauthorizedException || e is BadRequestException) {
          emit(const AuthFailure(error: 'Invalid email or password.'));
        } else {
          emit(AuthFailure(error: e.message));
        }
      },
    );

    if (user != null && !isClosed) {
      log('AuthCubit: Login successful for ${user.runtimeType} ${user.name}.');
      emit(AuthAuthenticated(user: user));
    }
  }

  // --- Registration ---
  Future<void> registerUserAndLogin({
    required String name,
    required String email,
    required String password,
  }) async {
    await _handleRegistrationProcess(
      userType: 'USER',
      email: email,
      registerFunction: () => _authService.registerUser(
        name: name,
        email: email,
        password: password,
      ),
      loginFunction: () => loginUser(email: email, password: password),
    );
  }

  Future<void> registerBusinessClientAndLogin({
    required String name,
    required String email,
    required String password,
    required String taxId,
  }) async {
    await _handleRegistrationProcess(
      userType: 'BUSINESS',
      email: email,
      registerFunction: () => _authService.registerBusinessClient(
        name: name,
        email: email,
        password: password,
        taxId: taxId,
      ),
      loginFunction: () =>
          loginBusinessClient(email: email, password: password),
    );
  }

  // --- Login ---
  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    await _handleLoginProcess(
      userType: 'USER',
      email: email,
      loginFunction: () =>
          _authService.loginUser(email: email, password: password),
    );
  }

  Future<void> loginBusinessClient({
    required String email,
    required String password,
  }) async {
    await _handleLoginProcess(
      userType: 'BUSINESS CLIENT',
      email: email,
      loginFunction: () => _authService.loginBusinessClient(
        email: email,
        password: password,
      ),
    );
  }

  // --- Logout ---
  Future<void> logout(BuildContext context) async {
    if (state is AuthUnauthenticated) return;
    log('AuthCubit: Logging out...');
    try {
      await _authService.logout();
      if (isClosed) return;
      emit(const AuthUnauthenticated(message: 'Successfully logged out.'));

      if (context.mounted) {
        context.go('/welcome');
      }
    } catch (e) {
      log('AuthCubit: Logout failed unexpectedly: $e');
      if (isClosed) return;
      emit(
        const AuthUnauthenticated(
          message: 'Logout failed, session cleared locally.',
        ),
      );
    }
  }

  // --- Update User ---
  Future<void> updateUserProfile(BaseUser updatedUser) async {
    if (state is AuthAuthenticated) {
      final user = updatedUser;
      log('AuthCubit: Updating user profile for ${user.id}');

      try {
        // Call the AuthService to update the user profile
        if (user is User) {
          final updatedUserProfile = await _authService.updateUserProfile(
            user.id,
            user.name,
            user.email,
            user.hobbies ?? List.empty(),
          );
          emit(AuthAuthenticated(user: updatedUserProfile));
        } else if (user is BusinessClient) {
          final updatedBusinessClient =
              await _authService.updateBusinessClientProfile(
            user.id,
            user.name,
            user.email,
            user.taxId,
          );
          emit(AuthAuthenticated(user: updatedBusinessClient));
        }
      } catch (e) {
        log('AuthCubit: Error updating profile: $e');
        emit(const AuthFailure(error: 'Failed to update profile.'));
      }
    } else {
      log('AuthCubit: Cannot update profile for unauthenticated user.');
      emit(
        const AuthFailure(
          error: 'Cannot update profile for unauthenticated user.',
        ),
      );
    }
  }

  void resetAuthStateAfterFailure() {
    if (state is AuthFailure && !isClosed) {
      log('AuthCubit: Resetting state to unauthenticated after auth failure.');
      emit(const AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    log('AuthCubit: Closing...');
    _userSubscription?.cancel();
    _authService.dispose();
    return super.close();
  }
}
