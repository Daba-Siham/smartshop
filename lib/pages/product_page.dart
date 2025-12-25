import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
import 'cart_page.dart';
import '../services/db_service.dart'; // <-- pour SQLite favoris

// Panier en mémoire
List<Map<String, dynamic>> cart = [];

// (facultatif) ancienne liste favoris en mémoire, si encore utilisée ailleurs
List<Map<String, dynamic>> favorites = [];

// Si tu ne l'utilises plus, tu peux supprimer ces deux fonctions :
bool isFavLocal(String name) => favorites.any((item) => item['name'] == name);

void toggleFavLocal(Map<String, dynamic> product) {
  final index = favorites.indexWhere((item) => item['name'] == product['name']);
  if (index != -1) {
    favorites.removeAt(index);
  } else {
    favorites.add(product);
  }
}

// ---- Panier : on garde la logique, mais on ajoute un paramètre quantité ----
void addToCart(Map<String, dynamic> product, {int quantity = 1}) {
  final index = cart.indexWhere((item) => item['name'] == product['name']);
  if (index != -1) {
    cart[index]['quantity'] += quantity;
  } else {
    cart.add({
      "name": product['name'],
      "price": product['price'],
      "image": product['image'],
      "description": product['description'],
      "rating": product['rating'],
      "quantity": quantity,
    });
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String name;
  final double price;
  final String image;
  final String description;
  final double rating;

  const ProductDetailsPage({
    super.key,
    required this.name,
    required this.price,
    required this.image,
    required this.description,
    required this.rating,
  });

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  bool added = false;
  int quantity = 1;

  bool isFavoriteProduct = false;

  @override
  void initState() {
    super.initState();
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    final fav = await isFavorite(widget.name); // vient de db_service.dart
    if (mounted) {
      setState(() => isFavoriteProduct = fav);
    }
  }

  Future<void> _toggleFavorite() async {
    final name = widget.name;
    final price = widget.price;
    final imagePath = widget.image;

    if (isFavoriteProduct) {
      await deleteFavoriteByName(name);
    } else {
      await addFavorise(name: name, price: price, imagePath: imagePath);
    }

    if (!mounted) return;

    setState(() {
      isFavoriteProduct = !isFavoriteProduct;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isFavoriteProduct
              ? "$name ajouté aux favoris"
              : "$name retiré des favoris",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("SmartShop"),
        actions: [
          IconButton(
            icon: Icon(
              isFavoriteProduct ? Icons.favorite : Icons.favorite_border,
              color: isFavoriteProduct ? Colors.red : null,
            ),
            onPressed: _toggleFavorite,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(widget.image, height: 200)),
            const SizedBox(height: 16),

            Text(
              widget.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),

            Text(widget.description, style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 16),

            Row(
              children: [
                for (int i = 0; i < widget.rating.floor(); i++)
                  const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(widget.rating.toString(),
                    style: const TextStyle(fontSize: 16)),
              ],
            ),

            const SizedBox(height: 16),

            Text(
              "Prix : ${widget.price} DH",
              style: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 111, 246, 120),
              ),
            ),

            const SizedBox(height: 24),

            // --------- Choix de quantité ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Quantité",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        if (quantity > 1) {
                          setState(() => quantity--);
                        }
                      },
                      icon: const Icon(Icons.remove),
                    ),
                    Text(
                      quantity.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() => quantity++);
                      },
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 8),

            Text(
              "Total : ${widget.price * quantity} DH",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),

      // ------- Bouton panier : on garde le principe de ton projet -------
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              added = !added;

              if (added) {
                final productMap = {
                  "name": widget.name,
                  "price": widget.price,
                  "image": widget.image,
                  "description": widget.description,
                  "rating": widget.rating,
                };

                addToCart(productMap, quantity: quantity);
              } else {
                cart.removeWhere((item) => item['name'] == widget.name);
              }
            });

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  added
                      ? "Produit ajouté au panier (x$quantity) !"
                      : "Produit retiré du panier !",
                ),
              ),
            );

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const CartPage(),
              ),
            );
          },
          child: Text(added ? "Retirer du Panier" : "Ajouter au Panier"),
        ),
      ),
    );
  }
}

class ProductsPage extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductsPage({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Tous les produits")),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: List.generate(
            products.length,
            (index) {
              final product = products[index];
              return ProductCard(
                name: product['name'],
                price: product['price'],
                image: product['image'],
                description: product['description'],
                rating: product['rating'],
              );
            },
          ),
        ),
      ),
    );
  }
}
