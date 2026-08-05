import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

class ProductRepository {
  Future<List<Product>> loadProducts() async {
    final jsonString = await rootBundle.loadString('assets/products.json');
    final decoded = json.decode(jsonString) as List<dynamic>;
    return decoded.map((entry) => Product.fromJson(entry as Map<String, dynamic>)).toList();
  }
}
