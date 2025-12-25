import 'package:flutter/material.dart';
import '../pages/product_page.dart';
import '../services/db_service.dart';
import '../history/log.dart';

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
  bool isFav = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final fav = await isFavorite(widget.name);
    setState(() {
      isFav = fav;
    });
  }

  Future<void> _toggleFavorite() async {
    final price = double.parse(widget.price);

    if (isFav) {
      await deleteFavoriteByName(widget.name);
      Log.actions.add("Produit ${widget.name} retiré des favoris");
    } else {
      await addFavorise(
        name: widget.name,
        price: price,
        imagePath: widget.imgPath,
      );
      Log.actions.add("Produit ${widget.name} ajouté aux favoris");
    }

    setState(() {
      isFav = !isFav;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFav
              ? "${widget.name} a été ajouté aux favoris"
              : "${widget.name} a été retiré des favoris",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset(
            widget.imgPath,
            height: 60,
            width: 60,
            fit: BoxFit.cover,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.price} DH",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.grey,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
    );
  }
}
