class Person {
  final int id;
  final String name;
  final String? urlImage;
  final DateTime? createdAt;

  Person({
    required this.id,
    required this.name,
    this.urlImage,
    this.createdAt,
  });
}
