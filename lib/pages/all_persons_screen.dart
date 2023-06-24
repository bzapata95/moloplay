import 'package:flutter/material.dart';
import 'package:molopay/app/presentation/global/colors.dart';
import 'package:molopay/app/presentation/global/modal_action_person.dart';
import 'package:molopay/models/person.dart';
import 'package:molopay/utils/formatted_currency.dart';
import 'package:molopay/utils/formatted_person.dart';
import 'package:molopay/widgets/avatar.dart';

import '../helpers/sql_helpers.dart';

class AllPersonsScreen extends StatefulWidget {
  const AllPersonsScreen({super.key});

  @override
  State<AllPersonsScreen> createState() => _AllPersonsScreenState();
}

class _AllPersonsScreenState extends State<AllPersonsScreen> {
  String searchText = "";
  List<Person> persons = [];

  Future<void> onLoadTransactions() async {
    final transactionsSql = await SQLHelper.getPersons();
    persons = formattedPerson(transactionsSql);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    onLoadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          onSubmitted: (value) {},
          onChanged: (e) {
            setState(() {
              searchText = e;
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
          ),
        ),
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          itemBuilder: (_, index) {
            final person = persons[index];
            return Column(
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
                                  const Text('Debe: '),
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
            );
          },
          itemCount: persons.length),
    );
  }
}
