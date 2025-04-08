class Event {

  Event({
    required this.eventId,
    required this.title,
    required this.organizerId,
    required this.startTime,
    required this.endTime,
    required this.price,
    required this.maxUsers,
    required this.minUsers,
    required this.description,
    required this.user,
    required this.relatedHobbies, this.venue,
    this.location,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      eventId: json['eventId'] as int,
      organizerId: json['organizerId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: DateTime.parse(json['endTime'] as String),
      venue: json['venue'] as String?,
      location: json['location'] as String?,
      price: (json['price'] as num).toDouble(),
      maxUsers: json['maxUsers'] as int,
      minUsers: json['minUsers'] as int,
      description: json['description'] as String?,
      user: json['user'] as String?,
      title: json['title'] as String?,
      relatedHobbies: json['relatedHobbies'] as List<String>,
    );
  }
  final int eventId;
  final int organizerId;
  final DateTime startTime;
  final DateTime endTime;
  final String? venue;
  final String? location;
  final double price;
  final int maxUsers;
  final int minUsers;
  final String? description;
  final String? user;
  final String? title;
  final List<String> relatedHobbies;
}
