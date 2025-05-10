import 'dart:async';
import 'dart:developer';

import 'package:actilink/events/logic/events_state.dart';
import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EventsCubit extends Cubit<EventsState> {
  EventsCubit({required EventRepository eventRepository})
      : _eventRepository = eventRepository,
        super(const EventsState());

  final EventRepository _eventRepository;

  Future<void> fetchEvents() async {
    if (state.status == EventsStatus.loading) return;
    emit(state.copyWith(status: EventsStatus.loading, error: ''));
    try {
      GeoLocationCacheService().clearCache();
      final events = await _eventRepository.getAllEvents();
      emit(state.copyWith(status: EventsStatus.success, events: events));
      log('Fetched ${events.length} events successfully.');
    } on ApiException catch (e) {
      log('Error fetching events: $e');
      emit(state.copyWith(status: EventsStatus.failure, error: e.message));
    } catch (e) {
      log('Unexpected error fetching events: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'An unexpected error occurred.',
        ),
      );
    }
  }

  Future<bool> addEvent(Event event) async {
    emit(state.copyWith(status: EventsStatus.loading));
    try {
      await _eventRepository.createEvent(event);
      log('Event added successfully: ${event.title}');
      final events = await _eventRepository.getAllEvents();
      emit(state.copyWith(status: EventsStatus.success, events: events));
      return true;
    } on ApiException catch (e) {
      log('Error adding event: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'Failed to add event: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error adding event: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'An unexpected error occurred while adding event.',
        ),
      );
      return false;
    }
  }

  Future<Event?> updateEvent(String eventId, Event event) async {
    emit(state.copyWith(status: EventsStatus.loading));
    try {
      final updatedEvent = await _eventRepository.updateEvent(eventId, event);
      log('Event updated successfully: ${updatedEvent.title}');
      final updatedList = state.events.map((e) {
        return e.id == eventId ? updatedEvent : e;
      }).toList();
      emit(state.copyWith(status: EventsStatus.success, events: updatedList));
      return updatedEvent;
    } on ApiException catch (e) {
      log('Error updating event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'Failed to update event: ${e.message}',
        ),
      );
      return null;
    } catch (e) {
      log('Unexpected error updating event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'An unexpected error occurred while updating event.',
        ),
      );
      return null;
    }
  }

  Future<bool> deleteEvent(String eventId) async {
    emit(state.copyWith(status: EventsStatus.loading));
    try {
      await _eventRepository.deleteEvent(eventId);
      log('Event deleted successfully: $eventId');
      final updatedList = state.events.where((e) => e.id != eventId).toList();
      emit(state.copyWith(status: EventsStatus.success, events: updatedList));
      return true;
    } on ApiException catch (e) {
      log('Error deleting event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'Failed to delete event: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error deleting event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'An unexpected error occurred while deleting event.',
        ),
      );
      return false;
    }
  }

  Future<bool> enrollInEvent(String eventId, BaseUser user) async {
    emit(state.copyWith(status: EventsStatus.loading));
    try {
      final event = await _eventRepository.enrollInEvent(eventId);
      log('Successfully enrolled in event: $eventId');
      final updatedList = state.events.map((e) {
        return e.id == eventId ? event : e;
      }).toList();
      emit(state.copyWith(status: EventsStatus.success, events: updatedList));
      return true;
    } on ApiException catch (e) {
      log('Error enrolling in event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'Failed to enroll in event: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error enrolling in event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'An unexpected error occurred while enrolling in event.',
        ),
      );
      return false;
    }
  }

  Future<bool> withdrawFromEvent(String eventId, BaseUser user) async {
    emit(state.copyWith(status: EventsStatus.loading));
    try {
      final event = await _eventRepository.withdrawFromEvent(eventId);
      log('Successfully withdrew from event: $eventId');
      final updatedList = state.events.map((e) {
        return e.id == eventId ? event : e;
      }).toList();
      emit(state.copyWith(status: EventsStatus.success, events: updatedList));
      return true;
    } on ApiException catch (e) {
      log('Error withdrawing from event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'Failed to withdraw from event: ${e.message}',
        ),
      );
      return false;
    } catch (e) {
      log('Unexpected error withdrawing from event $eventId: $e');
      emit(
        state.copyWith(
          status: EventsStatus.failure,
          error: 'An unexpected error occurred while withdrawing from event.',
        ),
      );
      return false;
    }
  }
}
