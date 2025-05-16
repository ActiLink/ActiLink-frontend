import 'package:core/src/models/event.dart';
import 'package:core/src/models/location.dart';
import 'package:equatable/equatable.dart';

// This DTO is used for creating new venues
class NewVenueDto {
  const NewVenueDto({
    required this.name,
    required this.description,
    required this.location,
    required this.address,
  });

  final String name;
  final String description;
  final Location location;
  final String address;

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'location': location.toJson(),
        'address': address,
      };
}

// This DTO is used for updating venues
class UpdateVenueDto extends NewVenueDto {
  const UpdateVenueDto({
    required super.name,
    required super.description,
    required super.location,
    required super.address,
  });
}

class VenueOwner extends Equatable {
  const VenueOwner({
    required this.id,
    required this.name,
  });

  factory VenueOwner.fromJson(Map<String, dynamic> json) {
    return VenueOwner(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
    );
  }

  final String id;
  final String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  @override
  List<Object?> get props => [id, name];
}

class Venue extends Equatable {
  const Venue({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.address,
    this.owner,
    this.events = const [],
  });

factory Venue.fromJson(Map<String, dynamic> json) {
    final locationJson = json['location'] as Map<String, dynamic>?;
    final eventsJson = json['events'] as List<dynamic>? ?? [];
    final eventsList = eventsJson
        .map((e) => Event.fromJson(e as Map<String, dynamic>))
        .toList();

    return Venue(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      location: locationJson != null
          ? Location.fromJson(locationJson)
          : const Location(latitude: 0, longitude: 0),
      address: json['address'] as String? ?? '',
      owner: json['owner'] != null
          ? VenueOwner.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
      events: eventsList,
    );
}

  final String id;
  final String name;
  final String description;
  final Location location;
  final String address;
  final VenueOwner? owner;
  final List<Event> events;

  // For creating new venues
  NewVenueDto toNewVenueDto() => NewVenueDto(
        name: name,
        description: description,
        location: location,
        address: address,
      );

  // For updating venues
  UpdateVenueDto toUpdateVenueDto() => UpdateVenueDto(
        name: name,
        description: description,
        location: location,
        address: address,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'location': location.toJson(),
        'address': address,
        'owner': owner?.toJson(),
        'events': events.map((e) => e.toJson()).toList(),
      };

  Venue copyWith({
    String? id,
    String? name,
    String? description,
    Location? location,
    String? address,
    VenueOwner? owner,
    List<Event>? events,
  }) {
    return Venue(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      location: location ?? this.location,
      address: address ?? this.address,
      owner: owner ?? this.owner,
      events: events ?? this.events,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        location,
        address,
        owner,
        events,
      ];
}
