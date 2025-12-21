import 'package:flutter/material.dart';
import '../widgets/product_card.dart';
// import 'product_page.dart';
import 'cart_page.dart';

List <Map<String, dynamic>> cart = [];
List <Map<String, dynamic>> favorites = [];

bool isFav(String name) => favorites.any((item) => item['name'] == name);

void toggleFav(Map<String , dynamic> product) {
  final index = favorites.indexWhere((item) => item['name'] == product['name']);
  if (index != -1) {
    favorites.removeAt(index);
  } else {
    favorites.add(product);
  }
}
void addToCart(Map<String , dynamic> product) {
  final index = cart.indexWhere((item) => item['name'] == product['name']);
  if (index != -1) {
    cart[index]['quantity'] += 1;
  } else {
    cart.add({
      "name": product['name'],
      "price": product['price'],
      "image": product['image'],
      "description": product['description'],
      "rating": product['rating'],
      "quantity": 1,
    });
  }
}

class ProductDetailsPage extends StatefulWidget {
  final String name;
  final double price;
  final String image;
  final String description;
  final double rating;

  ProductDetailsPage({
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("SmartShop")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.asset(widget.image, height: 200)),
            const SizedBox(height: 16),
            Text(widget.name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(widget.description, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Row(
              children: [
                for (int i = 0; i < widget.rating.floor(); i++)
                  const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text(widget.rating.toString(), style: const TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 16),
            Text("Prix : ${widget.price} DH",
                style: const TextStyle(
                    fontSize: 20, color: Color.fromARGB(255, 111, 246, 120))),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              added = !added;
              if (added) {
                final index = cart.indexWhere ((item)=> item['name'] == widget.name);
                if (index != -1){
                  cart[index]['quantity']+=1;
                }
                else{
                  cart.add({
                  "name": widget.name,
                  "price": widget.price,
                  "image": widget.image,
                  "description": widget.description,
                  "rating": widget.rating,
                  "quantity": 1,
                });
                }
                
              } else {
                cart.removeWhere((item) => item['name'] == widget.name);
              }
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(added ? "Produit ajouté au panier !" : "Produit retiré du panier !"))
,
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CartPage(),
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
