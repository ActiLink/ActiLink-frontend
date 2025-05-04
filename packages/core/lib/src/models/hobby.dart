import 'package:equatable/equatable.dart';

class Hobby extends Equatable {
  const Hobby({
    required this.name,
  });

  factory Hobby.fromJson(Map<String, dynamic> json) => Hobby(
        name: json['name'] as String? ?? '',
      );

  final String name;

  Map<String, dynamic> toJson() => {
        'name': name,
      };

  @override
  List<Object?> get props => [name];
}
