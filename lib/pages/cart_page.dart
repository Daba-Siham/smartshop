import 'package:flutter/material.dart';
import 'product_page.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double get totalCart {
    double total = 0;
    for (final product in cart) {
      final price = double.parse(product['price'].toString());
      final qty = product['quantity'] as int;
      total += price * qty;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Panier")),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                "Votre panier est vide",
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final product = cart[index];
                      final price =
                          double.parse(product['price'].toString());
                      final qty = product['quantity'] as int;

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              product['image'],
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(
                            product['name'],
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text("Prix unitaire : ${price.toStringAsFixed(2)} DH"),
                              const SizedBox(height: 4),

                              // Ligne quantité
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        if (qty > 1) {
                                          product['quantity'] = qty - 1;
                                        } else {
                                          cart.removeAt(index);
                                        }
                                      });
                                    },
                                    icon: const Icon(Icons.remove_circle),
                                    iconSize: 22,
                                  ),
                                  Text(
                                    qty.toString(),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      setState(() {
                                        product['quantity'] = qty + 1;
                                      });
                                    },
                                    icon: const Icon(Icons.add_circle),
                                    iconSize: 22,
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Total : ${(price * qty).toStringAsFixed(2)} DH",
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                cart.removeAt(index);
                              });
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total panier :",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${totalCart.toStringAsFixed(2)} DH",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
