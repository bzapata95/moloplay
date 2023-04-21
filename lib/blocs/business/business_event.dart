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
