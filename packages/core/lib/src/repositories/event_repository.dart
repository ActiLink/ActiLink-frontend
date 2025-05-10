import 'dart:developer';

import 'package:core/src/models.dart';
import 'package:core/src/services.dart';

class EventRepository {
  EventRepository({required ApiService apiService}) : _apiService = apiService;

  final ApiService _apiService;

  Future<List<Event>> getAllEvents() async {
    try {
      final response = await _apiService.getData('/Events');
      if (response is List) {
        return response
            .map(
              (eventData) => Event.fromJson(eventData as Map<String, dynamic>),
            )
            .toList();
      } else {
        log('getAllEvents: Unexpected response format: $response');
        throw ApiException('Invalid response format when fetching events.');
      }
    } catch (e) {
      log('getAllEvents Error: $e');
      rethrow;
    }
  }

  Future<Event> getEventById(String id) async {
    try {
      final response = await _apiService.getData('/Events/$id');
      if (response is Map<String, dynamic>) {
        return Event.fromJson(response);
      } else {
        log('getEventById: Unexpected response format for ID $id: $response');
        throw ApiException('Invalid response format when fetching event $id.');
      }
    } catch (e) {
      log('getEventById Error for ID $id: $e');
      rethrow;
    }
  }

  Future<void> createEvent(Event event) async {
    try {
      final newEventData = event.toNewOrUpdateJson();
      log('Creating event with data: $newEventData');
      await _apiService.postData('/Events', newEventData);
    } catch (e) {
      log('createEvent Error: $e');
      rethrow;
    }
  }

  Future<Event> updateEvent(String id, Event event) async {
    try {
      final updateEventData = event.toNewOrUpdateJson();
      log('Updating event $id with data: $updateEventData');
      final response =
          await _apiService.putData('/Events/$id', updateEventData);
      if (response is Map<String, dynamic>) {
        return Event.fromJson(response);
      } else {
        log('updateEvent: Unexpected response format for ID $id: $response');
        throw ApiException('Invalid response format after updating event $id.');
      }
    } catch (e) {
      log('updateEvent Error for ID $id: $e');
      rethrow;
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      log('Deleting event $id');
      await _apiService.deleteData('/Events/$id');
    } catch (e) {
      log('deleteEvent Error for ID $id: $e');
      rethrow;
    }
  }

  Future<Event> enrollInEvent(String eventId) async {
    try {
      log('Enrolling in event $eventId');
      final response = await _apiService.postData('/Events/$eventId/enroll');
      if (response is Map<String, dynamic>) {
        return Event.fromJson(response);
      } else {
        log('enrollInEvent: Unexpected response format for ID $eventId: $response');
        throw ApiException(
          'Invalid response format when enrolling in event $eventId.',
        );
      }
    } catch (e) {
      log('enrollInEvent Error for ID $eventId: $e');
      rethrow;
    }
  }

  Future<Event> withdrawFromEvent(String eventId) async {
    try {
      log('Withdrawing from event $eventId');
      final response = await _apiService.postData('/Events/$eventId/withdraw');
      if (response is Map<String, dynamic>) {
        return Event.fromJson(response);
      } else {
        log('withdrawFromEvent: Unexpected response format for ID $eventId: $response');
        throw ApiException(
          'Invalid response format when withdrawing from event $eventId.',
        );
      }
    } catch (e) {
      log('withdrawFromEvent Error for ID $eventId: $e');
      rethrow;
    }
  }
}
