import 'package:molopay/models/person.dart';

List<Person> formattedPerson(
  List<Map<String, dynamic>> persons, {
  bool withDateTransaction = true,
}) {
  print("$persons");
  final formatted = persons
      .map((e) => Person(
            id: e['id'],
            name: e['name'],
            urlImage: e['urlImage'],
            balance: double.tryParse(e['balance'].toString()) ?? 0,
            createdAt: e['createdAt'],
            dateTransaction: withDateTransaction
                ? DateTime.parse(e['dateTransaction'])
                : null,
          ))
      .toList();
  return formatted;
}
