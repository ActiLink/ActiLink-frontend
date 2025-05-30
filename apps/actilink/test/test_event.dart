import 'package:core/core.dart';

class TestEventFactory {
  static Event create({
    String? id,
    String title = 'Sample Event',
    String description = 'Sample Description',
    DateTime? startTime,
    DateTime? endTime,
    Location? location,
    double price = 10.0,
    int minUsers = 2,
    int maxUsers = 10,
    List<Hobby>? hobbies,
    EventOrganizer? organizer,
    List<EventParticipant>? participants,
    Venue? venue,
  }) {
    return Event(
      id: id ?? 'test-id',
      title: title,
      description: description,
      startTime: startTime ?? DateTime(2025, 5, 30, 16, 21),
      endTime: endTime ??
          DateTime(2025, 5, 30, 16, 21).add(const Duration(hours: 2)),
      location: location ?? const Location(latitude: 0, longitude: 0),
      price: price,
      minUsers: minUsers,
      maxUsers: maxUsers,
      hobbies: hobbies ?? [const Hobby(name: 'Chess')],
      organizer:
          organizer ?? const EventOrganizer(id: 'org-1', name: 'Organizer'),
      participants:
          participants ?? [const EventParticipant(id: 'u1', name: 'John')],
      venue: venue ??
          const Venue(
            id: 'v1',
            name: 'Test Venue',
            address: '123 Street',
            description: '',
            location: Location(latitude: 0, longitude: 0),
          ),
    );
  }
}
