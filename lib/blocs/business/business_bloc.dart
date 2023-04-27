import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:molopay/helpers/sql_helpers.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  BusinessBloc()
      : super(const BusinessState(
          persons: [],
          personSelected: null,
          transactions: [],
        )) {
    on<OnAddPersonEvent>(_onAddPersons);
    on<OnLoadPersonsOfDbEvent>(((event, emit) => emit(state.copyWith(
          persons: event.persons,
        ))));
    on<OnRegisterTransactionEvent>(((event, emit) => emit(state.copyWith(
          personSelected: event.person,
          typeTransaction: event.type,
        ))));
    on<OnCreateTransactionEvent>(_onCreateTransaction);
    on<OnLoadTotalBalanceEvent>(
        ((event, emit) => emit(state.copyWith(totalBalance: event.amount))));
    on<OnLoadTransactionsEvent>(((event, emit) => emit(state.copyWith(
          transactions: event.transactions,
        ))));
    on<OnToggleVisibilityTotalBalanceEvent>(((event, emit) async {
      final SharedPreferences pref = await SharedPreferences.getInstance();
      final boolean = !state.isVisibilityTotalBalance;
      pref.setBool("isVisibilityTotalBalance", boolean);
      emit(state.copyWith(
        isVisibilityTotalBalance: boolean,
      ));
    }));
    on<OnInitialLoadSharedUserPreference>(((event, emit) => emit(state.copyWith(
          isVisibilityTotalBalance: event.isVisibilityTotalBalance,
        ))));

    _init();
  }

  Future<void> _init() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final isVisibilityTotalBalance = pref.getBool("isVisibilityTotalBalance");
    final persons = await SQLHelper.getPersons();
    await loadTransactions();
    await loadTotalBalance();

    final formatted = persons
        .map((e) => Person(
              id: e['id'],
              name: e['name'],
              urlImage: e['urlImage'],
              balance: double.tryParse(e['balance'].toString()) ?? 0,
              createdAt: e['createdAt'],
            ))
        .toList();

    add(OnLoadPersonsOfDbEvent(formatted));
    add(OnInitialLoadSharedUserPreference(
        isVisibilityTotalBalance: isVisibilityTotalBalance ?? true));
  }

  Future<void> loadTransactions() async {
    final transactions = await SQLHelper.getTransactions();
    final formattedTransactions = transactions
        .map((e) => Transaction(
              amount: double.parse(e['amount'].toString()),
              createdAt: DateTime.parse(e['createAt']),
              id: e['id'],
              name: e['name'],
              type: e['type'] != null ? e['type'].toString() : "",
              description: e['description'],
            ))
        .toList();
    add(OnLoadTransactionsEvent(formattedTransactions));
  }

  Future<void> loadTotalBalance() async {
    final totalBalance = await SQLHelper.sumTotalBalance();
    add(OnLoadTotalBalanceEvent(totalBalance));
  }

  _onAddPersons(OnAddPersonEvent event, Emitter<BusinessState> emit) async {
    final personInsert = await SQLHelper.createPerson(name: event.name);
    final person = Person(
        id: personInsert, name: event.name, balance: double.parse('0.0'));
    emit(state.copyWith(persons: [person, ...state.persons]));
  }

  _onCreateTransaction(
      OnCreateTransactionEvent event, Emitter<BusinessState> emit) async {
    final person = event.person;
    final typeTransaction = event.type;
    final amount = event.amount;
    final description = event.description;

    await SQLHelper.createTransaction(
        amount: amount,
        person: person,
        type: typeTransaction,
        description: description);

    final newMap = state.persons.map((e) {
      if (e.id == event.person.id) {
        final calculateAmount = event.type == TypeTransaction.give
            ? (person.balance ?? 0) + amount
            : (person.balance ?? 0) - amount;

        return Person(
            id: person.id,
            name: person.name,
            balance: calculateAmount,
            createdAt: person.createdAt);
      }
      return e;
    }).toList();
    await Future.wait([loadTotalBalance(), loadTransactions()]);
    add(OnLoadPersonsOfDbEvent(newMap));
  }
}
