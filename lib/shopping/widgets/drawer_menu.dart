import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extensions.dart';

import '../../consts.dart';
import '../../globals.dart';
import '../providers/products.dart';
import '../screens/orders_screen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final productContainer = Provider.of<Products>(context);
    return Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: Globals
                    .configuration.homeScreen.backgroundUrl.toImageProvider,
                fit: BoxFit.cover,
              ),
            ),
            child: Image(
              image: Globals
                  .configuration.homeScreen.logoField.url.toImageProvider,
            ),
          ),
          ListTile(
            title: Text(
              "${tr('Welcome')} ${FirebaseAuth.instance.currentUser?.email ?? ''}",
              style: TextStyle(
                color: Globals.configuration.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ListTile(
            title: Text(tr('products')),
            onTap: () {
              productContainer.showAll();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(tr('favourites')),
            onTap: () {
              productContainer.showFavorite();
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(tr('orders')),
            onTap: () {
              Navigator.of(context)
                ..pop()
                ..pushNamed(OrdersScreen.routeName);
            },
          ),
          ListTile(
            title: Text(tr('quit_to_home')),
            onTap: () {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(AppConsts.landingRoute);
            },
          ),
        ],
      ),
    );
  }
}
