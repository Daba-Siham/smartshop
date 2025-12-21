import 'package:flutter/material.dart';
import 'product_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Favoris")),
      body: favorites.isEmpty
          ? const Center(child: Text("Aucun favori"))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (_, index) {
                final p = favorites[index];
                return ListTile(
                  leading: Image.asset(p["image"], width: 50, height: 50),
                  title: Text(p["name"]),
                  subtitle: Text("${p["price"]} DH"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        favorites.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
    );
  }
}
