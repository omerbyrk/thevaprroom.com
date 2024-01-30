import '../defaults.dart';
import '../../../shopping/model/product.dart';

class ShoppingModel {
  final String priceUnit;
  final List<Product> products;

  const ShoppingModel({required this.priceUnit, required this.products});

  factory ShoppingModel.fromMap(Map map) {
    return ShoppingModel(
      priceUnit: map["price_unit"] ?? Defaults.shoppingModel.priceUnit,
      products: ((map["products"] ?? Defaults.shoppingModel.products)
              as List<dynamic>)
          .map((e) => Product.fromJson(e))
          .toList()
          .cast<Product>(),
    );
  }

  Map<String, dynamic> toMap() =>
      {"price_unit": priceUnit, "products": products};
}
