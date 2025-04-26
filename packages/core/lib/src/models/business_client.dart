import 'package:core/src/models/organizer.dart';

class BusinessClient extends Organizer {
  const BusinessClient({
    required super.id, required super.name, required super.email, required this.taxId,
  });

  factory BusinessClient.fromJson(Map<String, dynamic> json) {
    return BusinessClient(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      taxId: json['taxId'] as String,
    );
  }

  final String taxId;

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json['taxId'] = taxId;
    return json;
  }

  BusinessClient copyWith({
    String? id,
    String? name,
    String? email,
    String? taxId,
  }) {
    return BusinessClient(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      taxId: taxId ?? this.taxId,
    );
  }

  @override
  List<Object?> get props => [...super.props, taxId];
}
