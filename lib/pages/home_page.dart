import 'package:flutter/material.dart';
import '../widgets/product_tile.dart';
import '../widgets/section_title.dart';
import 'profile_page.dart';
import 'search_page.dart';
import 'settings_page.dart';
import 'history_page.dart';
import 'product_page.dart';
import 'cart_page.dart';
import '../history/log.dart';
import 'favorites_page.dart';
import '../services/json_service.dart';
import '../models/product.dart';
import '../services/db_service.dart';
import 'api_product_page.dart';
import 'add_product_api_page.dart.dart';
import 'edit_product_api_page.dart';
import 'settings_page.dart';
import 'prefs_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const Map<String, String> profile = {
    "name": "Siham Daba",
    "email": "sihamdaba@gmail.com",
    "avatar": "assets/cute.jpg",
    "telephone": "0604115980",
    "address": "123 Rue Exemple, Ville, Pays",
    "job": "AI student"
  };

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<String> categories = [
    "Tous",
    "Phones",
    "Laptops",
    "Watch",
    "Gaming",
    "Accessoires"
  ];

  String selectedCategory = "Tous";

  void _showProductBottomSheet(Map<String, dynamic> product) {
    Log.actions.add("Produit ${product['name']} consulté");

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                height: 140,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    product["image"],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                product["name"],
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                "${product["price"]} DH",
                style: const TextStyle(
                  fontSize: 18,
                  color: Colors.blue,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        addToCart(product);
                        Log.actions.add("Produit ${product['name']} ajouté au panier");
                        Navigator.pop(context);
                        ScaffoldMessenger.of(this.context).showSnackBar(
                          SnackBar(content: Text("${product['name']} a été ajouté au panier")),
                        );
                        setState(() {});
                      },
                      icon: const Icon(Icons.add_shopping_cart),
                      label: const Text("Ajouter au panier"),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        Navigator.push(
                          this.context,
                          MaterialPageRoute(
                            builder: (_) => ProductDetailsPage(
                              name: product["name"],
                              price: double.parse(product["price"].toString()),
                              image: product["image"],
                              description: product["description"],
                              rating: (product["rating"] as num).toDouble(),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(Icons.info_outline),
                      label: const Text("Voir détails"),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: FutureBuilder<bool>(
                      future: isFavorite(product["name"].toString()),
                      builder: (context, snapshot) {
                        final alreadyFavorite = snapshot.data ?? false;

                        return OutlinedButton.icon(
                          onPressed: () async {
                            final name = product["name"].toString();

                            final rawPrice = product["price"];
                            final price = (rawPrice is num)
                                ? rawPrice.toDouble()
                                : double.parse(rawPrice.toString());

                            final imagePath = product["image"].toString();

                            if (alreadyFavorite) {
                              await deleteFavoriteByName(name);
                              Log.actions.add("Produit $name retiré des favoris");
                            } else {
                              await addFavorise(
                                name: name,
                                price: price,
                                imagePath: imagePath,
                              );
                              Log.actions.add("Produit $name ajouté aux favoris");
                            }

                            if (mounted) {
                              ScaffoldMessenger.of(this.context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    alreadyFavorite
                                        ? "$name retiré des favoris"
                                        : "$name ajouté aux favoris",
                                  ),
                                ),
                              );
                              setState(() {});
                            }
                          },
                          icon: Icon(
                            alreadyFavorite ? Icons.favorite : Icons.favorite_border,
                            color: alreadyFavorite ? Colors.red : Colors.grey,
                          ),
                          label: Text(
                            alreadyFavorite ? "Retirer" : "Favori",
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _openSearch() {
    Log.actions.add("Ouverture page Recherche");
    Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
  }

  void _openSettings() {
    Log.actions.add("Ouverture page Paramètres");
    Navigator.push(context, MaterialPageRoute(builder: (_) => const PrefsPage()));
  }

  void _openHistory() {
    Log.actions.add("Ouverture page Historique");
    Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
  }

  void _openProfile() {
    Log.actions.add("Ouverture page Profil");
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfilePage(
          name: HomePage.profile['name']!,
          email: HomePage.profile['email']!,
          avatar: HomePage.profile['avatar']!,
          telephone: HomePage.profile['telephone']!,
          address: HomePage.profile['address']!,
          job: HomePage.profile['job']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Center(
                child: Text("SmartShop Menu", style: TextStyle(color: Colors.white, fontSize: 20)),
              ),
            ),
            ListTile(leading: const Icon(Icons.settings), title: const Text("Paramètres"), onTap: _openSettings),
            ListTile(leading: const Icon(Icons.history), title: const Text("Historique"), onTap: _openHistory),
            ListTile(leading: const Icon(Icons.person), title: const Text("Profil"), onTap: _openProfile),
            ListTile(
              leading: const Icon(Icons.favorite),
              title: const Text("Favoris"),
              onTap: () {
                Log.actions.add("Ouverture page Favoris");
                Navigator.push(context, MaterialPageRoute(builder: (_) => const FavoritesPage()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text("Panier"),
              onTap: () {
                Log.actions.add("Ouverture page Panier");
                Navigator.push(context, MaterialPageRoute(builder: (_) => CartPage()));
              },
            ),
            ListTile(leading: const Icon(Icons.search), title: const Text("Recherche"), onTap: _openSearch),
          ],
        ),
      ),

      appBar: AppBar(
        title: const Text("SmartShop"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: _openSearch),
          IconButton(
          icon: const Icon(Icons.cloud_download),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ApiProductPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddProductApiPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const EditProductApiPage()),
            );
          },
      )
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SectionTitle(title: "Catégories"),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) {
                final isSelected = (cat == selectedCategory);
                return GestureDetector(
                  onTap: () => setState(() => selectedCategory = cat),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      cat,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(
              "Catégorie sélectionnée : $selectedCategory",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          const SectionTitle(title: "Produits"),

          Expanded(
            child: FutureBuilder<List<Product>>(
              future: JsonService.loadProducts(),
              builder: (_, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final allProducts = snapshot.data!;
                final filteredProducts = selectedCategory == "Tous"
                    ? allProducts
                    : allProducts.where((p) =>
                        p.category.trim().toLowerCase() == selectedCategory.trim().toLowerCase()).toList();

                if (filteredProducts.isEmpty) {
                  return const Center(child: Text("Aucun produit dans cette catégorie", style: TextStyle(fontSize: 16)));
                }

                return ListView(
                  children: filteredProducts.map((product) {
                    return GestureDetector(
                      onTap: () => _showProductBottomSheet({
                        "name": product.name,
                        "price": product.price,
                        "image": product.image,
                        "description": product.description,
                        "rating": product.rating,
                      }),
                      child: ProductTile(
                        imgPath: product.image,
                        name: product.name,
                        price: product.price.toString(),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
