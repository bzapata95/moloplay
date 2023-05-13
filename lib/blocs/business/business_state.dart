part of 'business_bloc.dart';

class BusinessState extends Equatable {
  final List<Person> persons;
  final Person? personSelected;
  final TypeTransaction? typeTransaction;
  final String totalBalance;
  final List<Transaction> transactions;
  final bool isVisibilityTotalBalance;
  final bool isSupportedAuthBiometrics;

  const BusinessState({
    required this.persons,
    required this.transactions,
    this.personSelected,
    this.typeTransaction,
    this.totalBalance = "0.00",
    this.isVisibilityTotalBalance = false,
    this.isSupportedAuthBiometrics = false,
  });

  BusinessState copyWith({
    List<Person>? persons,
    Person? personSelected,
    TypeTransaction? typeTransaction,
    String? totalBalance,
    List<Transaction>? transactions,
    bool? isVisibilityTotalBalance,
    bool? isSupportedAuthBiometrics,
  }) =>
      BusinessState(
        persons: persons ?? this.persons,
        personSelected: personSelected,
        typeTransaction: typeTransaction ?? this.typeTransaction,
        totalBalance: totalBalance ?? this.totalBalance,
        transactions: transactions ?? this.transactions,
        isVisibilityTotalBalance:
            isVisibilityTotalBalance ?? this.isVisibilityTotalBalance,
        isSupportedAuthBiometrics:
            isSupportedAuthBiometrics ?? this.isSupportedAuthBiometrics,
      );

  @override
  List<Object?> get props => [
        persons,
        personSelected,
        typeTransaction,
        totalBalance,
        transactions,
        isVisibilityTotalBalance,
        isSupportedAuthBiometrics,
      ];
}
