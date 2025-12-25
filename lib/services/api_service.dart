import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiException implements Exception {
  final String message;
  ApiException(this.message);

  @override
  String toString() => message;
}

class ApiProduct {
  final int id;
  final String name;
  final double price;
  final String description;
  final String? imgPath;

  ApiProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imgPath,
  });

  factory ApiProduct.fromJson(Map<String, dynamic> json) {
    return ApiProduct(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      imgPath: json['imgPath'] as String?,
    );
  }
}

class ApiService {
  static const String baseUrl = 'http://192.168.1.12:5000/api';

  static Future<List<ApiProduct>> fetchProducts() async {
    final url = Uri.parse('$baseUrl/products');

    try {
      final response =
          await http.get(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final List data = jsonDecode(response.body);
        return data.map((e) => ApiProduct.fromJson(e)).toList();
      } else if (response.statusCode >= 500) {
        throw ApiException('Erreur serveur – Réessayez plus tard');
      } else {
        throw ApiException('Erreur serveur : code ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('Erreur réseau – Vérifiez votre connexion');
    } on TimeoutException {
      throw ApiException('Délai dépassé – Réessayez plus tard (timeout)');
    }
  }

  static Future<ApiProduct> addProduct({
    required String name,
    required double price,
    required String description,
    String? imgPath,
  }) async {
    final url = Uri.parse('$baseUrl/products');

    final body = <String, dynamic>{
      'name': name,
      'price': price,
      'description': description,
    };
    if (imgPath != null) {
      body['imgPath'] = imgPath;
    }

    try {
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        return ApiProduct(
          id: data['id'] as int,
          name: name,
          price: price,
          description: description,
          imgPath: imgPath,
        );
      } else if (response.statusCode >= 500) {
        throw ApiException('Erreur serveur – Réessayez plus tard');
      } else {
        throw ApiException('Erreur serveur : code ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('Erreur réseau – Vérifiez votre connexion');
    } on TimeoutException {
      throw ApiException('Délai dépassé – Réessayez plus tard (timeout)');
    }
  }

  static Future<void> updateProduct({
    required int id,
    required String name,
    required String description,
    required double price,
    String? imgPath,
  }) async {
    final url = Uri.parse('$baseUrl/products/$id');

    final body = <String, dynamic>{
      "name": name,
      "description": description,
      "price": price,
    };
    if (imgPath != null) {
      body["imgPath"] = imgPath;
    }

    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Erreur lors de la mise à jour (${response.statusCode})");
    }
  }

  static Future<void> deleteProduct(int id) async {
    final url = Uri.parse('$baseUrl/products/$id');

    try {
      final response =
          await http.delete(url).timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        return;
      } else if (response.statusCode >= 500) {
        throw ApiException('Erreur serveur – Réessayez plus tard');
      } else {
        throw ApiException('Erreur serveur : code ${response.statusCode}');
      }
    } on SocketException {
      throw ApiException('Erreur réseau – Vérifiez votre connexion');
    } on TimeoutException {
      throw ApiException('Délai dépassé – Réessayez plus tard (timeout)');
    }
  }

  static Future<List<dynamic>> getProducts() async {
    final url = Uri.parse('$baseUrl/products');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Impossible de récupérer les produits");
    }
  }

   static Future<String> uploadImage(File file) async {
    final url = Uri.parse('$baseUrl/upload_image');

    final request = http.MultipartRequest('POST', url);
    request.files.add(
      await http.MultipartFile.fromPath('image', file.path),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      return data['url'] as String;
    } else {
      throw Exception(
          "Erreur upload image (${response.statusCode}) : ${response.body}");
    }
  }


}
