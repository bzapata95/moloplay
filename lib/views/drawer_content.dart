import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../blocs/authentication/authentication_bloc.dart';
import '../routes/routes.dart';

class ItemListTile {
  final String title;
  final String route;

  ItemListTile(this.title, this.route);
}

class DrawerContentView extends StatelessWidget {
  final GlobalKey<ScaffoldState> keyScaffold;
  const DrawerContentView({super.key, required this.keyScaffold});

  @override
  Widget build(BuildContext context) {
    final authenticationBloc =
        BlocProvider.of<AuthenticationBloc>(context, listen: false);

    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(30)),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: CachedNetworkImage(
                      imageUrl: 'https://github.com/bzapata95.png',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const CircularProgressIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error)),
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                authenticationBloc.username,
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
          Divider(
            height: 50,
          ),
          ...generateListTile(
              [ItemListTile('Contacts', Routes.allPersons)], context)
        ],
      ),
    ));
  }

  generateListTile(List<ItemListTile> items, BuildContext context) {
    return items.map(
      (e) => ListTile(
        contentPadding: EdgeInsets.zero,
        onTap: () {
          keyScaffold.currentState!.closeDrawer();
          Navigator.pushNamed(context, e.route);
        },
        title: Text(
          e.title,
          style: const TextStyle(
            fontFamily: 'Montserrat',
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
