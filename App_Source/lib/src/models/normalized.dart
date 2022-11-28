class Normalized {
  final int id;
  final String name;

  Normalized({
    required this.id,
    required this.name,
  });

  factory Normalized.fromJson(Map<String, dynamic> json) {
    return Normalized(
      id: json['id'],
      name : json['name'],
    );
  }
}