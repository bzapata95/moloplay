import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:molopay/helpers/sql_helpers.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc()
      : super(const BusinessState(
          persons: [],
          personSelected: null,
        )) {
    on<OnAddPersonEvent>(_onAddPersons);
    on<OnLoadPersonsOfDbEvent>(((event, emit) => emit(state.copyWith(
          persons: event.persons,
        ))));
    on<OnSelectedPersonForRegisterTransactionEvent>(
        ((event, emit) => emit(state.copyWith(
              personSelected: event.person,
              typeTransaction: event.type,
            ))));
    on<OnCreateTransactionEvent>(_onCreateTransaction);

    _init();
  }

  Future<void> _init() async {
    final persons = await SQLHelper.getPersons();
    final formatted = persons
        .map((e) => Person(
              id: e['id'],
              name: e['name'],
              urlImage: e['urlImage'],
              createdAt: e['createdAt'],
            ))
        .toList();
    add(OnLoadPersonsOfDbEvent(formatted));
  }

  _onAddPersons(OnAddPersonEvent event, Emitter<BusinessState> emit) async {
    final personInsert = await SQLHelper.createPerson(name: event.name);
    final person = Person(id: personInsert, name: event.name);
    emit(state.copyWith(persons: [person, ...state.persons]));
  }

  _onCreateTransaction(
      OnCreateTransactionEvent event, Emitter<BusinessState> emit) async {
    final person = event.person;
    final typeTransaction = event.type;
    final amount = event.amount;

    final idTransaction = await SQLHelper.createTransaction(
      amount: amount,
      personId: person.id,
      type: typeTransaction,
    );

    print(idTransaction);
  }
}
