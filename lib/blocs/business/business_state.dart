part of 'business_bloc.dart';

class BusinessState extends Equatable {
  final List<Person> persons;
  final Person? personSelected;
  final TypeTransaction? typeTransaction;
  final String totalBalance;
  final List<Transaction> transactions;

  const BusinessState({
    required this.persons,
    this.personSelected,
    this.typeTransaction,
    this.totalBalance = "0.00",
    required this.transactions,
  });

  BusinessState copyWith({
    List<Person>? persons,
    Person? personSelected,
    TypeTransaction? typeTransaction,
    String? totalBalance,
    List<Transaction>? transactions,
  }) =>
      BusinessState(
        persons: persons ?? this.persons,
        personSelected: personSelected,
        typeTransaction: typeTransaction ?? this.typeTransaction,
        totalBalance: totalBalance ?? this.totalBalance,
        transactions: transactions ?? this.transactions,
      );

  @override
  List<Object?> get props => [
        persons,
        personSelected,
        typeTransaction,
        totalBalance,
        transactions,
      ];
}
