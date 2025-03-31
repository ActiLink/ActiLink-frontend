import 'dart:async';
import 'dart:developer';

import 'package:actilink/auth/logic/auth_state.dart';
import 'package:bloc/bloc.dart';
import 'package:core/core.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    _initialize();
  }

  final AuthService _authService;
  StreamSubscription<User?>? _userSubscription;

  void _initialize() {
    _userSubscription = _authService.userStream.listen(_onUserChanged);
    checkAuthStatus();
  }

  void _onUserChanged(User? user) {
    if (isClosed) return;
    final currentState = state;
    if (user != null) {
      if (currentState is AuthAuthenticated && currentState.user == user) {
        return;
      }
      log('AuthCubit: User stream indicates authentication: ${user.name}');
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
      if (user == null && state is AuthLoading) {
        emit(
          const AuthUnauthenticated(
            message: 'No valid session found.',
          ),
        );
      }
    } catch (e) {
      log('AuthCubit: Error during initial auth check: $e');
      if (isClosed) return;
      emit(const AuthFailure(error: 'Failed to verify login status.'));
    }
  }

  Future<void> registerAndLogin({
    required String name,
    required String email,
    required String password,
  }) async {
    if (state is AuthLoading) return;
    log('AuthCubit: Registering and logging in user $email...');
    emit(const AuthLoading(message: 'Creating account and signing in...'));
    try {
      final user = await _authService.registerAndLogin(
        name: name,
        email: email,
        password: password,
      );
      if (isClosed) return;

      log('AuthCubit: Register and Login successful for ${user.name}.');
      emit(AuthAuthenticated(user: user));
    } on ApiException catch (e) {
      log('AuthCubit: RegisterAndLogin Error: $e');
      if (isClosed) return;
      if (e is ConflictException) {
        emit(AuthFailure(error: "Email '$email' is already registered."));
      } else if (e is BadRequestException) {
        emit(AuthFailure(error: 'Registration or login failed: ${e.message}'));
      } else {
        emit(AuthFailure(error: e.message));
      }
    } catch (e) {
      log('AuthCubit: RegisterAndLogin Generic Error: $e');
      if (isClosed) return;
      emit(
        const AuthFailure(
          error: 'An unknown error occurred during sign up.',
        ),
      );
    }
  }

  Future<void> login({required String email, required String password}) async {
    if (state is AuthLoading) return;
    log('AuthCubit: Logging in $email...');
    emit(const AuthLoading(message: 'Signing in...'));
    try {
      final user = await _authService.login(email: email, password: password);
      if (isClosed) return;
      log('AuthCubit: Login successful for ${user.name}.');
      emit(AuthAuthenticated(user: user));
    } on ApiException catch (e) {
      log('AuthCubit: Login Error: $e');
      if (isClosed) return;
      if (e is UnauthorizedException || e is BadRequestException) {
        emit(const AuthFailure(error: 'Invalid email or password.'));
      } else {
        emit(AuthFailure(error: e.message));
      }
    } catch (e) {
      log('AuthCubit: Login Generic Error: $e');
      if (isClosed) return;
      emit(const AuthFailure(error: 'An unknown error occurred during login.'));
    }
  }

  Future<void> logout() async {
    if (state is AuthUnauthenticated) return;
    log('AuthCubit: Logging out...');
    try {
      await _authService.logout();
      if (isClosed) return;
      emit(
        const AuthUnauthenticated(
          message: 'Successfully logged out.',
        ),
      );
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

  void resetAuthStateAfterFailure() {
    if (state is AuthFailure) {
      log('AuthCubit: Resetting state after auth failure.');
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
