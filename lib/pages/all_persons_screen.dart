import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:molopay/app/presentation/global/colors.dart';
import 'package:molopay/app/presentation/global/modal_action_person.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/routes/routes.dart';
import 'package:molopay/utils/formatted_currency.dart';
import 'package:molopay/utils/formatted_person.dart';
import 'package:molopay/widgets/avatar.dart';

import '../app/presentation/global/open_modal_add_person.dart';
import '../blocs/business/business_bloc.dart';
import '../helpers/sql_helpers.dart';
import '../models/transaction.dart';

class AllPersonsScreen extends StatefulWidget {
  const AllPersonsScreen({super.key, this.onlySelect = false});

  final bool onlySelect;

  @override
  State<AllPersonsScreen> createState() => _AllPersonsScreenState();
}

class _AllPersonsScreenState extends State<AllPersonsScreen> {
  TextEditingController _controller = TextEditingController();
  String searchText = '';
  List<Person> persons = [];

  Future<void> onLoadPersons() async {
    final transactionsSql = await SQLHelper.getPersons();
    persons = formattedPerson(transactionsSql, withDateTransaction: false);
    setState(() {});
  }

  Future<void> onSearchPerson(String searchText) async {
    if (searchText.isNotEmpty) {
      final transactionsSql = await SQLHelper.searchPerson(searchText);
      persons = formattedPerson(transactionsSql, withDateTransaction: false);
      setState(() {});
    } else {
      onLoadPersons();
    }
  }

  @override
  void initState() {
    super.initState();
    onLoadPersons();
  }

  @override
  Widget build(BuildContext context) {
    final businessBloc = BlocProvider.of<BusinessBloc>(context, listen: true);
    return Scaffold(
      appBar: AppBar(
        actions: [
          if (!widget.onlySelect)
            IconButton(
                onPressed: () {
                  openModalAddPerson(context, onRegister: () async {
                    Future.delayed(const Duration(milliseconds: 100), () {
                      onLoadPersons();
                    });
                  });
                },
                icon: const Icon(Icons.add)),
        ],
        title: TextField(
          controller: _controller,
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {
            onSearchPerson(value);
          },
          onChanged: (v) {
            setState(() {
              searchText = v;
            });
          },
          decoration: InputDecoration(
              fillColor: AppColors.green500,
              hintStyle: TextStyle(color: Colors.grey.withOpacity(0.5)),
              hintText: 'Search person',
              prefixIcon: const Icon(
                Icons.search,
              ),
              hoverColor: AppColors.green500,
              focusColor: AppColors.green500,
              prefixIconColor: Colors.grey.withOpacity(0.5),
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          searchText = '';
                        });
                        _controller.clear();
                        onLoadPersons();
                      },
                    )
                  : null),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          itemBuilder: (_, index) {
            final person = persons[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              dense: true,
              onTap: widget.onlySelect
                  ? () {
                      if (widget.onlySelect) {
                        businessBloc.add(OnRegisterTransactionEvent(
                            person: person,
                            type: businessBloc.state.typeTransaction!));
                        Navigator.pushReplacementNamed(
                            context, Routes.registerTransaction);
                      }
                    }
                  : null,
              title: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Avatar(
                                name: person.name,
                                urlImage: person.urlImage,
                                radius: 50),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  person.name,
                                  style: const TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  children: [
                                    const Text('Debt: '),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      formattedCurrency(double.parse(
                                          '${person.balance}' ?? '0')),
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )
                          ],
                        ),
                        if (!widget.onlySelect)
                          IconButton(
                              onPressed: () {
                                openModalActionPerson(context, person);
                              },
                              icon: const Icon(Icons.more_vert_outlined)),
                      ],
                    ),
                  ),
                  const Divider()
                ],
              ),
            );
          },
          itemCount: persons.length),
    );
  }
}
