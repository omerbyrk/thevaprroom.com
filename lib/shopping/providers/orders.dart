import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'cart.dart';

class Address {
  final String address;
  final String address2;
  final String postcode;
  final String city;

  Address({
    required this.address,
    required this.address2,
    required this.postcode,
    required this.city,
  });

  Address.fromJson(Map<String, dynamic> json)
      : address = json['address'],
        address2 = json['address2'],
        postcode = json['postcode'],
        city = json['city'];

  Map<String, dynamic> toJson() => {
        'address': address,
        'address2': address2,
        'postcode': postcode,
        'city': city,
      };
}

class OrderItem with ChangeNotifier {
  final String id;
  final double amount;
  final List<CartItem> orderedProducts;
  final Address address;
  final DateTime datetime;
  bool isExpanded = false;

  OrderItem({
    required this.id,
    required this.amount,
    required this.address,
    required this.orderedProducts,
    required this.datetime,
  });

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        orderedProducts = (json['orderedProducts'] as List<dynamic>)
            .map((e) => CartItem.fromJson(e))
            .toList()
            .cast<CartItem>(),
        address = Address.fromJson(json['address']),
        datetime = DateTime.parse(json['datetime'].toString());

  Map<String, dynamic> toJson() => {
        'id': id,
        'amount': amount,
        'orderedProducts': orderedProducts,
        'address': address.toJson(),
        'datetime': datetime.toString(),
      };

  void toggleExpanded() {
    isExpanded = !isExpanded;
    debugPrint("this item is expanded - $isExpanded");
    notifyListeners();
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Orders() {
    getOrders();
  }

  void getOrders() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var orderString = sharedPreferences.getString("ORDERS") ?? "";

    if (orderString.isNotEmpty) {
      Iterable<dynamic> orderObject = jsonDecode(orderString);
      for (var order in orderObject) {
        OrderItem orderItem = OrderItem.fromJson(order);
        _orders.add(orderItem);
      }
      notifyListeners();
    }
  }

  Future<void> saveOrders() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (_orders.isEmpty) {
      await sharedPreferences.remove("ORDERS");
    } else {
      await sharedPreferences.setString("ORDERS", jsonEncode(_orders));
    }
  }

  void addOder(
      List<CartItem> cartProducts, double total, Address address) async {
    _orders.add(OrderItem(
      amount: total,
      datetime: DateTime.now(),
      address: address,
      id: Random().nextInt(100).toString(),
      orderedProducts: cartProducts,
    ));
    await saveOrders();
    notifyListeners();
  }

  void clearAll() async {
    _orders = [];
    await saveOrders();
    notifyListeners();
  }
}
