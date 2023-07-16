class Person {
  final int id;
  final String name;
  final String? urlImage;
  final DateTime? createdAt;
  final double? balance;
  final DateTime? dateTransaction;

  Person({
    required this.id,
    required this.name,
    this.urlImage,
    this.createdAt,
    this.balance,
    this.dateTransaction,
  });
}
