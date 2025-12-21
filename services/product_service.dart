import 'dart:convert';
import 'package:flutter/services.dart';

class ProductService {
  Future<List<dynamic>> loadProducts() async {
    final data = await rootBundle.loadString("assets/products.json");
    return jsonDecode(data);
  }
}
