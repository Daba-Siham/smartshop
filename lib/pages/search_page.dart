import 'package:flutter/material.dart';
// import 'home_page.dart';
import '../widgets/product_tile.dart';
import '../history/log.dart';
import '../models/product.dart';
import '../services/json_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  // List<Map<String, dynamic>> filteredList = HomePage.products;

  List<Product> allProducts = [];
  List<Product> filteredList = [];

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    final products = await JsonService.loadProducts();
    setState(() {
      allProducts = products;
      filteredList = products;
    });
  }

  void searchProduct(String query) {
    setState(() {
      if (query.isEmpty) {
        // filteredList = HomePage.products;
        filteredList = allProducts;
      } else {
        // filteredList = HomePage.products
        filteredList = allProducts
            .where(
              (p) => p.name
                  .toLowerCase()
                  .contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  void validateSearch() {
    final query = _controller.text.trim();

    if (query.isNotEmpty) {
      Log.actions.add("Recherche effectuée : $query");
    }

    searchProduct(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Recherche")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onChanged: searchProduct,
                    onSubmitted: (_) => validateSearch(),
                    decoration: const InputDecoration(
                      hintText: "Rechercher un produit...",
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: validateSearch, 
                  child: const Text("OK"),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (_, index) {
                final item = filteredList[index];

                return ProductTile(
                  imgPath: item.image,
                  name: item.name,
                  price: item.price.toString(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
