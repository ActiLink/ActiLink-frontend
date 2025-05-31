import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

/// Extension on [MockCubit] to simplify emitting states in tests.
extension MockCubitEmitExtension<T> on MockCubit<T> {
  /// When the specified function [fun] is called, emit the given [newState].
  void whenFunctionEmit<R>(
    R Function() fun,
    T newState, {
    bool isAsync = true,
  }) {
    if (isAsync) {
      when(fun).thenAnswer(
        (_) async {
          when(() => state).thenReturn(newState);
          return null;
        } as Answer<R>,
      );
    } else {
      when(fun).thenAnswer((_) {
        when(() => state).thenReturn(newState);
        return null as R;
      });
    }
  }

  /// When the specified function with arguments [fun] is called, use the [stateBuilder]
  /// to construct and emit a state based on the invocation.
  void whenFunctionEmitBuilder<R>(
    R Function() fun,
    T Function(Invocation invocation) stateBuilder, {
    bool isAsync = true,
  }) {
    if (isAsync) {
      when(fun).thenAnswer(
        (Invocation invocation) async {
          when(() => state).thenReturn(stateBuilder(invocation));
        } as Answer<R>,
      );
    } else {
      when(fun).thenAnswer((Invocation invocation) {
        when(() => state).thenReturn(stateBuilder(invocation));
        return null as R;
      });
    }
  }

  /// Set up the cubit to emit a single state when a BlocListener or BlocBuilder is connected
  void whenListenEmit(T state) {
    whenListen(this, Stream.value(state));
  }

  /// Set up the cubit to emit a sequence of states when a BlocListener or BlocBuilder is connected
  void whenListenEmitMany(List<T> states) {
    whenListen(this, Stream.fromIterable(states));
  }

  /// Set up the cubit to emit states from a custom stream when a BlocListener or BlocBuilder is connected
  void whenListenEmitStream(Stream<T> stateStream) {
    whenListen(this, stateStream);
  }

  /// Set up the cubit to simulate method call and then emit a state for BlocListener/BlocBuilder
  void whenFunctionListenEmit<R>(
    R Function() fun,
    T newState, {
    bool isAsync = true,
  }) {
    whenFunctionEmit(fun, newState, isAsync: isAsync);
    whenListenEmit(newState);
  }

  /// Set up the cubit to simulate method call and then emit multiple states for BlocListener/BlocBuilder
  void whenFunctionListenEmitMany<R>(
    R Function() fun,
    List<T> states, {
    bool isAsync = true,
  }) {
    if (states.isNotEmpty) {
      whenFunctionEmit(fun, states.last, isAsync: isAsync);
    }
    whenListenEmitMany(states);
  }

  /// Set up the cubit to simulate method call with dynamic state building for BlocListener/BlocBuilder
  /// This allows creating state sequences that depend on the method parameters
  void whenFunctionListenEmitBuilder<R>(
    R Function() fun,
    List<T> Function(Invocation invocation) statesBuilder, {
    bool isAsync = true,
  }) {
    when(fun).thenAnswer((Invocation invocation) {
      final states = statesBuilder(invocation);
      if (states.isNotEmpty) {
        whenFunctionEmit(fun, states.last, isAsync: isAsync);
      }
      whenListenEmitMany(states);
      if (isAsync) {
        return Future<R?>.value() as R;
      } else {
        return null as R;
      }
    });
  }
}
