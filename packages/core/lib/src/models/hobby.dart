class Hobby {
  Hobby({
    required this.id,
    required this.name,
  });

  factory Hobby.fromJson(Map<String, dynamic> json) => Hobby(
        id: json['id'] as String,
        name: json['name'] as String,
      );
  final String id;
  final String name;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };

  Map<String, dynamic> toNewOrUpdateJson() => {
        'name': name,
      };
}
