import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../extensions.dart';
import '../../globals.dart';
import '../providers/cart.dart';
import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product-detail';

  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final products = Provider.of<Products>(context);
    final product = products.findById(productId);
    final cart = Provider.of<Cart>(context, listen: false);

    return Scaffold(
      bottomSheet: Container(
        color: Globals.configuration.backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            child: TextButton(
              onPressed: () {
                cart.addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      tr("product_added_to_cart"),
                      textAlign: TextAlign.center,
                    ),
                  ).toStandart,
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    Globals.configuration.primaryColor),
                foregroundColor: MaterialStateProperty.all(
                    Globals.configuration.backgroundColor),
                textStyle: MaterialStateProperty.all(
                  const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              child: Text(tr("add_to_cart")),
            ),
          )
        ]),
      ),
      appBar: AppBar(
        title: Text(product.title),
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 300,
            width: double.infinity,
            child: Hero(
              tag: product.id,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Card(
            child: SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        tr("price"),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      Chip(
                        label: Text(
                          product.priceWithUnit,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      )
                    ]),
              ),
            ),
          ),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: const TextStyle(
                  fontSize: 17,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
