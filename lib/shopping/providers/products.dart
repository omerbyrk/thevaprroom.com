import 'package:flutter/material.dart';

import '../../globals.dart';
import '../model/product.dart';

class Products with ChangeNotifier {
  final List<Product> _items = Globals.configuration.shopping.products;

  var isFavoriteTapped = false;

  List<Product> get items {
    if (isFavoriteTapped) {
      return _items.where((product) => product.isFavourite).toList();
    }
    return [..._items];
  }

  Product findById(String productId) {
    return _items.firstWhere((p) => p.id == productId);
  }

  void showFavorite() {
    isFavoriteTapped = true;
    notifyListeners();
  }

  void showAll() {
    isFavoriteTapped = false;
    notifyListeners();
  }
}
