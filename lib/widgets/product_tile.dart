import 'package:flutter/material.dart';
import '../pages/product_page.dart';

class ProductTile extends StatefulWidget {
  final String imgPath;
  final String name;
  final String price;

  const ProductTile({
    super.key,
    required this.imgPath,
    required this.name,
    required this.price,
  });

  @override
  State<ProductTile> createState() => _ProductTileState();
}

class _ProductTileState extends State<ProductTile> {
  @override
  Widget build(BuildContext context) {
    final fav = isFav(widget.name);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Image.asset(widget.imgPath, height: 60, width: 60, fit: BoxFit.cover),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.price} DH",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              fav ? Icons.favorite : Icons.favorite_border,
              color: fav ? Colors.red : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                toggleFav({
                  "name": widget.name,
                  "price": widget.price,
                  "image": widget.imgPath,
                  "description": "",
                  "rating": 0.0,
                });
              });
            },
          ),
        ],
      ),
    );
  }
}
