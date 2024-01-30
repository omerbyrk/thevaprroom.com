import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../shopping.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool _isFavourite = false;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
  }) {
    getFavourite();
  }

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        description = json['description'],
        price = json['price'],
        imageUrl = json['imageUrl'] {
    getFavourite();
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'price': price,
        'imageUrl': imageUrl,
      };

  String get priceWithUnit => priceUnit + (price).toString();

  bool get isFavourite => _isFavourite;

  void toggleFavorite() async {
    _isFavourite = !_isFavourite;
    var sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.setBool("FAVOURITE.$id", _isFavourite);
    debugPrint("this item is favorite - $isFavourite");
    notifyListeners();
  }

  void getFavourite() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    _isFavourite = sharedPreferences.getBool("FAVOURITE.$id") ?? false;
    notifyListeners();
  }
}
