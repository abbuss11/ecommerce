import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Loads the mock catalog used by the shop screens.
class ProductRepository {
  Future<List<Product>> loadProducts() async {
    try {
      final jsonString = await rootBundle.loadString('assets/products.json');
      final decoded = json.decode(jsonString) as List<dynamic>;
      return decoded.map((entry) => Product.fromJson(entry as Map<String, dynamic>)).toList();
    } catch (error, stackTrace) {
      throw Exception('Unable to load product catalog: $error');
    }
  }
}
