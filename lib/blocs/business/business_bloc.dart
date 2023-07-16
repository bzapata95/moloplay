import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:local_auth/local_auth.dart';
import 'package:molopay/helpers/sql_helpers.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/models/transaction.dart';
import 'package:molopay/utils/formatted_person.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/formatted_currency.dart';
import '../../utils/formatted_transaction.dart';

part 'business_event.dart';
part 'business_state.dart';

class BusinessBloc extends Bloc<BusinessEvent, BusinessState> {
  final LocalAuthentication auth = LocalAuthentication();

  LocalAuthentication get authBiometrics => auth;

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
    on<OnValidateIsSupportedAuthBiometricsEvent>(
        ((event, emit) => emit(state.copyWith(
              isSupportedAuthBiometrics: event.isSupported,
            ))));

    _init();
  }

  Future<void> _init() async {
    auth.isDeviceSupported().then((bool isSupported) =>
        add(OnValidateIsSupportedAuthBiometricsEvent(isSupported)));
    final SharedPreferences pref = await SharedPreferences.getInstance();
    final isVisibilityTotalBalance = pref.getBool("isVisibilityTotalBalance");

    await loadPersonsRecent();
    await loadTransactions();
    await loadTotalBalance();

    add(OnInitialLoadSharedUserPreference(
        isVisibilityTotalBalance: isVisibilityTotalBalance ?? true));
  }

  Future<void> loadPersonsRecent() async {
    List<Map<String, dynamic>> persons =
        await SQLHelper.getPersonsWithTransactionRecent();
    var result = formattedPerson(persons);
    result.sort((a, b) => b.dateTransaction!.compareTo(a.dateTransaction!));

    //Los ponemos en un MAP
    Map<int, Person> uniqueObjectsMap = {};

    for (Person obj in result) {
      uniqueObjectsMap[obj.id] = obj;
    }

    add(OnLoadPersonsOfDbEvent(uniqueObjectsMap.values.toList()));
  }

  Future<void> loadTransactions() async {
    final transactions = await SQLHelper.getTransactions(limit: 8);
    final formattedTransactions = formattedTransaction(transactions);
    add(OnLoadTransactionsEvent(formattedTransactions));
  }

  Future<void> loadTotalBalance() async {
    final totalBalance = await SQLHelper.sumTotalBalance();
    String formattedAmount = formattedCurrency(double.parse(totalBalance));
    add(OnLoadTotalBalanceEvent(formattedAmount));
  }

  _onAddPersons(OnAddPersonEvent event, Emitter<BusinessState> emit) async {
    final personInsert = await SQLHelper.createPerson(name: event.name);
    final person = Person(
        id: personInsert, name: event.name, balance: double.parse('0.0'));
    // emit(state.copyWith(persons: [person, ...state.persons]));
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
          createdAt: person.createdAt,
          urlImage: person.urlImage,
        );
      }
      return e;
    }).toList();
    await Future.wait(
        [loadTotalBalance(), loadTransactions(), loadPersonsRecent()]);
    // add(OnLoadPersonsOfDbEvent(newMap));
  }
}
