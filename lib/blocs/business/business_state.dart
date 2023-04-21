part of 'business_bloc.dart';

class BusinessState extends Equatable {
  final List<Person> persons;

  const BusinessState({
    required this.persons,
  });

  BusinessState copyWith({
    List<Person>? persons,
  }) =>
      BusinessState(
        persons: persons ?? this.persons,
      );

  @override
  List<Object> get props => [persons];
}
