import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

enum EventsStatus { initial, loading, success, failure }

class EventsState extends Equatable {
  const EventsState({
    this.status = EventsStatus.initial,
    this.events = const <Event>[],
    this.error = '',
  });

  final EventsStatus status;
  final List<Event> events;
  final String error;

  EventsState copyWith({
    EventsStatus? status,
    List<Event>? events,
    String? error,
  }) {
    return EventsState(
      status: status ?? this.status,
      events: events ?? this.events,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, events, error];
}
