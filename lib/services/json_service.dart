import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/product.dart';

class JsonService {
  static Future<List<Product>> loadProducts() async {
    final data = await rootBundle.loadString('assets/products.json');
    final List<dynamic> jsonList = jsonDecode(data);
    return jsonList.map((e) => Product.fromJson(e)).toList();
  }

}
