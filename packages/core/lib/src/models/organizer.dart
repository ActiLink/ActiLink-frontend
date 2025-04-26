import 'package:equatable/equatable.dart';

abstract class Organizer extends Equatable {
  const Organizer({
    required this.id, required this.name, required this.email,
  });

  final String id;
  final String name;
  final String email;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }

  @override
  List<Object?> get props => [id, name, email];
}
