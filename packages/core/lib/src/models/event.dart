import 'package:core/src/models.dart';

class EventOrganizer {
  const EventOrganizer({
    required this.id,
    required this.name,
  });

  factory EventOrganizer.fromJson(Map<String, dynamic> json) {
    return EventOrganizer(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;
}

class EventParticipant {
  const EventParticipant({
    required this.id,
    required this.name,
  });

  factory EventParticipant.fromJson(Map<String, dynamic> json) {
    return EventParticipant(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;
}

class Event {
  const Event({
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.price,
    required this.minUsers,
    required this.maxUsers,
    required this.hobbies,
    this.id,
    this.organizer,
    this.participants,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>? ?? [];
    final participantsList = participantsJson
        .map((p) => EventParticipant.fromJson(p as Map<String, dynamic>))
        .toList();

    final hobbiesJson = json['hobbies'] as List<dynamic>? ?? [];
    final hobbiesList = hobbiesJson
        .map(
          (h) => Hobby.fromJson(
            h as Map<String, dynamic>,
          ),
        )
        .toList();

    final locationJson = json['location'] as Map<String, dynamic>?;

    return Event(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      startTime: DateTime.parse(
        json['startTime'] as String? ?? DateTime.now().toIso8601String(),
      ),
      endTime: DateTime.parse(
        json['endTime'] as String? ?? DateTime.now().toIso8601String(),
      ),
      location: locationJson != null
          ? Location.fromJson(locationJson)
          : const Location(latitude: 0, longitude: 0),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      minUsers: json['minUsers'] as int? ?? 1,
      maxUsers: json['maxUsers'] as int? ?? 0,
      hobbies: hobbiesList,
      organizer: EventOrganizer.fromJson(
        json['organizer'] as Map<String, dynamic>? ?? {},
      ),
      participants: participantsList,
    );
  }

  final String? id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final Location location;
  final double price;
  final int minUsers;
  final int maxUsers;
  final List<Hobby> hobbies;
  final EventOrganizer? organizer;
  final List<EventParticipant>? participants;

  Map<String, dynamic> toNewOrUpdateJson() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'location': location.toJson(),
      'price': price,
      'minUsers': minUsers,
      'maxUsers': maxUsers,
      'relatedHobbies': hobbies.map((hobby) => hobby.toJson()).toList(),
    };
  }

  Event copyWith({
    String? id,
    String? organizerId,
    String? title,
    String? description,
    DateTime? startTime,
    DateTime? endTime,
    Location? location,
    double? price,
    int? minUsers,
    int? maxUsers,
    List<Hobby>? hobbies,
    EventOrganizer? organizer,
    List<EventParticipant>? participants,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      price: price ?? this.price,
      minUsers: minUsers ?? this.minUsers,
      maxUsers: maxUsers ?? this.maxUsers,
      hobbies: hobbies ?? this.hobbies,
      organizer: organizer ?? this.organizer,
      participants: participants ?? this.participants,
    );
  }
}
