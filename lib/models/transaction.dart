enum TypeTransaction { give, receive }

class Transaction {
  final int id;
  final double amount;
  final String description;
  final String type;
  final String name;
  final DateTime createdAt;
  final String dateTransaction;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.name,
    required this.createdAt,
    required this.description,
    required this.dateTransaction,
  });
}
