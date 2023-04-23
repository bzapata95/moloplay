enum TypeTransaction { give, receive }

class Transaction {
  final int id;
  final double amount;
  final String type;
  final String name;
  final DateTime createdAt;

  Transaction(
      {required this.id,
      required this.amount,
      required this.type,
      required this.name,
      required this.createdAt});
}
