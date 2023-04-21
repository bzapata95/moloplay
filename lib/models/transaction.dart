import 'package:molopay/models/person.dart';

enum TypeTransaction { give, receive }

class Transaction {
  final String id;
  final double amount;
  final TypeTransaction type;
  final Person person;

  Transaction({
    required this.id,
    required this.amount,
    required this.type,
    required this.person,
  });
}
