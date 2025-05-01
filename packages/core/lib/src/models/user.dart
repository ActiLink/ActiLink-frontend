import 'package:core/src/models/base_user.dart';
import 'package:core/src/models/hobby.dart';

class User extends BaseUser {

  const User({
    required super.id,
    required super.name,
    required super.email,
    this.hobbies,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      hobbies: (json['hobbies'] as List<dynamic>?)
          ?.map((e) => Hobby.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
  final List<Hobby>? hobbies;

  User copyWith({
    String? id,
    String? name,
    String? email,
    List<Hobby>? hobbies,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      hobbies: hobbies ?? this.hobbies,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'hobbies': hobbies?.map((h) => h.toJson()).toList(),
    };
  }

  @override
  List<Object?> get props => [...super.props, hobbies];
}
