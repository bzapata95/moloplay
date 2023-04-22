part of 'business_bloc.dart';

class BusinessState extends Equatable {
  final List<Person> persons;
  final Person? personSelected;
  final TypeTransaction? typeTransaction;

  const BusinessState({
    required this.persons,
    this.personSelected,
    this.typeTransaction,
  });

  BusinessState copyWith({
    List<Person>? persons,
    Person? personSelected,
    TypeTransaction? typeTransaction,
  }) =>
      BusinessState(
        persons: persons ?? this.persons,
        personSelected: personSelected ?? this.personSelected,
        typeTransaction: typeTransaction ?? this.typeTransaction,
      );

  @override
  List<Object?> get props => [persons, personSelected, typeTransaction];
}
