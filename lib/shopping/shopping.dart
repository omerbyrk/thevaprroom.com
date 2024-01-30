import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

import '../globals.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/cart_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/place_order_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/product_overview_screen.dart';
import 'widgets/badge.dart' as b;
import 'widgets/drawer_menu.dart';

String priceUnit = Globals.configuration.shopping.priceUnit;

class ShoppingScreen extends StatelessWidget {
  const ShoppingScreen({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Products(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        title: tr("Store"),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            elevation: 0,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
            outlineBorder: BorderSide(color: Colors.black),
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
            ),
          ),
          scaffoldBackgroundColor: Colors.white,
          colorScheme: ColorScheme.fromSwatch(
            primarySwatch: Colors.cyan,
          ).copyWith(
            secondary: Globals.configuration.primaryColor,
          ),
        ),
        locale: context.deviceLocale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        home: MyHomePage(title: tr("Store")),

        //register all routes here
        routes: {
          ProductDetailScreen.routeName: (context) =>
              const ProductDetailScreen(),
          CartScreen.routeName: (context) => const CartScreen(),
          PlaceOrderScreen.routeName: (context) => const PlaceOrderScreen(),
          OrdersScreen.routeName: (context) => const OrdersScreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key, required this.title});

  final String title;
//
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          b.Badge(
            value: cart.itemCount.toString(),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
        title: Text(title),
        centerTitle: true,
      ),
      body: const ProductOverviewScreen(),
      drawer: const DrawerMenu(),
    );
  }
}
