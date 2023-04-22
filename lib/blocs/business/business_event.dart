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

class OnSelectedPersonForRegisterTransactionEvent extends BusinessEvent {
  final Person person;
  final TypeTransaction type;

  const OnSelectedPersonForRegisterTransactionEvent({
    required this.person,
    required this.type,
  });
}

class OnCreateTransactionEvent extends BusinessEvent {
  final Person person;
  final TypeTransaction type;
  final double amount;

  const OnCreateTransactionEvent({
    required this.person,
    required this.type,
    required this.amount,
  });
}
