import 'package:flutter/material.dart';
import '../pages/product_page.dart';

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final String description;
  final double rating;

  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(child: Image.asset(image)),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("$price DH", style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsPage(
                      name: name,
                      price: price,
                      image: image,
                      description: description,
                      rating: rating,
                    ),
                  ),
                );
              },
              child: const Text("Détails"),
            ),
          ],
        ),
      ),
    );
  }
}
