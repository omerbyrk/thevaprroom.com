import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../model/product.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({super.key});

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
        },
        child: GridTile(
          header: GridTileBar(
            backgroundColor: Colors.black45,
            leading: Text(
              product.title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w400),
            ),
            title: const SizedBox(width: 20),
            trailing: Text(
              product.priceWithUnit,
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          footer: GridTileBar(
            backgroundColor: Colors.black87,
            leading: IconButton(
              icon: Icon(
                  product.isFavourite ? Icons.favorite : Icons.favorite_border),
              color: Colors.red,
              onPressed: () {
                //toggle here
                product.toggleFavorite();
              },
            ),
            title: const SizedBox(width: 20),
            trailing: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(product);
              },
            ),
          ),
          child: Hero(
            tag: product.id,
            child: Image.network(
              product.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
