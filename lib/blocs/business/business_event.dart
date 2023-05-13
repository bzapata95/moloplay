part of 'business_bloc.dart';

abstract class BusinessEvent extends Equatable {
  const BusinessEvent();

  @override
  List<Object> get props => [];
}

class OnAddPersonEvent extends BusinessEvent {
  final String name;

  const OnAddPersonEvent(this.name);
}

class OnLoadPersonsOfDbEvent extends BusinessEvent {
  final List<Person> persons;

  const OnLoadPersonsOfDbEvent(this.persons);
}

class OnRegisterTransactionEvent extends BusinessEvent {
  final Person? person;
  final TypeTransaction type;

  const OnRegisterTransactionEvent({
    this.person,
    required this.type,
  });
}

class OnCreateTransactionEvent extends BusinessEvent {
  final Person person;
  final TypeTransaction type;
  final double amount;
  final String description;

  const OnCreateTransactionEvent({
    required this.person,
    required this.type,
    required this.amount,
    required this.description,
  });
}

class OnLoadTotalBalanceEvent extends BusinessEvent {
  final String amount;

  const OnLoadTotalBalanceEvent(this.amount);
}

class OnLoadTransactionsEvent extends BusinessEvent {
  final List<Transaction> transactions;

  const OnLoadTransactionsEvent(this.transactions);
}

class OnToggleVisibilityTotalBalanceEvent extends BusinessEvent {}

class OnInitialLoadSharedUserPreference extends BusinessEvent {
  final bool isVisibilityTotalBalance;

  const OnInitialLoadSharedUserPreference(
      {required this.isVisibilityTotalBalance});
}

class OnValidateIsSupportedAuthBiometricsEvent extends BusinessEvent {
  final bool isSupported;
  const OnValidateIsSupportedAuthBiometricsEvent(this.isSupported);
}
