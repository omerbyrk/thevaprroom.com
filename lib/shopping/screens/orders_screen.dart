import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../shopping.dart';

import '../../globals.dart';
import '../providers/orders.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders-screen';

  const OrdersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(tr("orders")),
        centerTitle: true,
      ),
      body: orders.orders.isEmpty
          ? Center(
              child: Text(
              tr("no_orders_to_display"),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ))
          : ListView.separated(
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (BuildContext context, int index) {
                return ChangeNotifierProvider.value(
                    value: orders.orders[index],
                    builder: (context, _) {
                      final order = Provider.of<OrderItem>(context);
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Globals.configuration.primaryColor,
                          child: Text(
                            "#${order.id}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          DateFormat('yyyy-MM-dd').format(order.datetime),
                        ),
                        trailing: Text(
                          "$priceUnit${order.amount.toStringAsFixed(2)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: order.isExpanded
                            ? SizedBox(
                                height: 200,
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      final cart = order.orderedProducts[index];
                                      return ListTile(
                                          title: Text(cart.title),
                                          subtitle: Text(
                                              "${cart.price} x ${cart.quantity}"),
                                          trailing: Text(
                                              "$priceUnit${(cart.price * cart.quantity).toStringAsFixed(2)}"));
                                    },
                                    itemCount: order.orderedProducts.length,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () {
                          order.toggleExpanded();
                        },
                      );
                    });
              },
              itemCount: orders.orders.length,
            ),
    );
  }
}
