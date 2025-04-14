import 'package:core/src/models.dart';

class Event {
  const Event({
    required this.id,
    required this.organizerId,
    required this.startTime,
    required this.endTime,
    required this.location,
    required this.price,
    required this.minUsers,
    required this.maxUsers,
    this.title,
    this.description,
    this.participants = const [],
    this.hobbies = const [],
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    final participantsJson = json['participants'] as List<dynamic>? ?? [];
    final participantsList = participantsJson
        .map((p) => User.fromJson(p as Map<String, dynamic>))
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
      organizerId: json['organizerId'] as String? ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
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
      participants: participantsList,
      hobbies: hobbiesList,
    );
  }

  final String id;
  final String organizerId;
  final String? title;
  final String? description;
  final DateTime startTime;
  final DateTime endTime;
  final Location location;
  final double price;
  final int minUsers;
  final int maxUsers;
  final List<User> participants;
  final List<Hobby> hobbies;

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
      'relatedHobbyIds': hobbies.map((hobby) => hobby.id).toList(),
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
    List<User>? participants,
    List<Hobby>? hobbies,
  }) {
    return Event(
      id: id ?? this.id,
      organizerId: organizerId ?? this.organizerId,
      title: title ?? this.title,
      description: description ?? this.description,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      location: location ?? this.location,
      price: price ?? this.price,
      minUsers: minUsers ?? this.minUsers,
      maxUsers: maxUsers ?? this.maxUsers,
      participants: participants ?? this.participants,
      hobbies: hobbies ?? this.hobbies,
    );
  }
}
