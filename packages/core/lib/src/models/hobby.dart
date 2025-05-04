class Hobby {
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

  Map<String, dynamic> toNewOrUpdateJson() => {
        'name': name,
      };
}
