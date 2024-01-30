import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions.dart';
import '../providers/cart.dart';
import '../shopping.dart';
import 'place_order_screen.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart-screen';

  const CartScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("cart")),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      tr("total"),
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Chip(
                      label: Text(cart.totalAmountWithUnit),
                    )
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Text(
                    tr("cart_is_empty"),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ))
                : ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return Dismissible(
                        key: ValueKey(cart.items.keys.toList()[index]),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          cart.removeItem(cart.items.keys.toList()[index]);
                        },
                        background: Container(
                          padding: const EdgeInsets.only(right: 20),
                          color: Theme.of(context).colorScheme.error,
                          alignment: Alignment.centerRight,
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.white,
                              child: Image.network(
                                cart.items.values
                                    .toList()[index]
                                    .product
                                    .imageUrl,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title:
                                Text(cart.items.values.toList()[index].title),
                            //
                            subtitle: Text(
                                "${cart.items.values.toList()[index].price} x ${cart.items.values.toList()[index].quantity}"),
                            trailing: Text(
                                "$priceUnit${(cart.items.values.toList()[index].price * cart.items.values.toList()[index].quantity).toStringAsFixed(2)}"),
                          ),
                        ),
                      );
                    },
                    itemCount: cart.itemCount,
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            child: TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Theme.of(context).colorScheme.secondary)),
              child: Text(
                tr("order_now"),
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () {
                if (cart.items.isNotEmpty) {
                  Navigator.of(context).pushNamed(PlaceOrderScreen.routeName);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        tr("account_is_deleted"),
                        textAlign: TextAlign.center,
                      ),
                    ).toStandart,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
