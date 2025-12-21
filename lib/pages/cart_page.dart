import 'package:flutter/material.dart';
import 'product_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mon Panier")),
      body: cart.isEmpty 
      ? const Center (child : Text("Mon Panier"))
      : ListView.builder(
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final product = cart[index];
          final price =  double.parse(product['price'].toString());
          final qty = product['quantity'] as int;
          return ListTile(
            leading: Image.asset(product['image'], width: 50, height: 50),
            title: Text(product['name']),
            subtitle : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Prix : ${product['price']} DH"),
                Text("Quantité : ${product['quantity']}"),
                Text("Total : ${price * qty} DH"),
              ],
            )
          );
        },
        
      ),
    );
  }
}