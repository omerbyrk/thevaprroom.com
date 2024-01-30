import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shopping.dart';

import '../model/product.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final Product product;

  CartItem({
    required this.id,
    required this.title,
    required this.quantity,
    required this.price,
    required this.product,
  });

  CartItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        quantity = json['quantity'],
        price = json['price'],
        product = Product.fromJson(json['product']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'quantity': quantity,
        'price': price,
        'product': product.toJson(),
      };
}

class Cart with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  Cart() {
    getCart();
  }
  void getCart() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var cartString = sharedPreferences.getString("CART") ?? "";

    if (cartString.isNotEmpty) {
      Map<String, dynamic> cartObject = jsonDecode(cartString);
      for (var key in cartObject.keys.toList()) {
        CartItem cartItem = CartItem.fromJson(cartObject[key]);
        _items[key] = cartItem;
      }
      notifyListeners();
    }
  }

  Future<void> saveCart() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (_items.isEmpty) {
      await sharedPreferences.remove("CART");
    } else {
      await sharedPreferences.setString("CART", jsonEncode(_items));
    }
  }

  String get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total = total + cartItem.price * cartItem.quantity;
    });
    return total.toStringAsFixed(2);
  }

  String get totalAmountWithUnit {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total = total + cartItem.price * cartItem.quantity;
    });
    return priceUnit + total.toStringAsFixed(2);
  }

  void addItem(Product product) async {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existing) => CartItem(
            id: existing.id,
            price: existing.price,
            quantity: existing.quantity + 1,
            title: existing.title,
            product: product),
      );
      debugPrint("${product.title} is added to cart multiple");
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(
            id: DateTime.now().toString(),
            price: product.price,
            quantity: 1,
            title: product.title,
            product: product),
      );
      debugPrint("${product.title} is added to cart");
    }
    await saveCart();
    notifyListeners();
  }

  void removeItem(String id) async {
    _items.remove(id);
    saveCart();
    await saveCart();
    notifyListeners();
  }

  void empty() async {
    _items.clear();
    await saveCart();
    notifyListeners();
  }
}
